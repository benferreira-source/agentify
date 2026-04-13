#!/opt/homebrew/bin/python3
"""
Agentify site server — port 8810
Serves /Users/dobby/Desktop/agentify/ (the new dark-aesthetic site).

Public:
  GET  /                 → index.html
  GET  /<path>           → static file from SITE_DIR

Admin (X-Admin-Token header required):
  GET  /admin/get        → returns current index.html content
  POST /admin/update     → replaces index.html (full body)
  POST /admin/patch      → JSON {"find": "...", "replace": "..."} — patches index.html
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import os, json, mimetypes, sys, traceback
from typing import Optional

SITE_DIR    = '/Users/dobby/Desktop/agentify'
ADMIN_FILE  = os.path.join(SITE_DIR, 'index.html')
ADMIN_TOKEN = 'agentify-harry-2026'
PORT        = 8810

# Good MIME types for the files we actually serve
mimetypes.add_type('image/svg+xml', '.svg')
mimetypes.add_type('image/png', '.png')
mimetypes.add_type('text/html; charset=utf-8', '.html')
mimetypes.add_type('application/json', '.json')
mimetypes.add_type('text/markdown; charset=utf-8', '.md')


class Handler(BaseHTTPRequestHandler):

    def _resolve(self, url_path):
        # type: (str) -> Optional[str]
        """Map URL path to a file path under SITE_DIR, blocking traversal."""
        url_path = url_path.split('?')[0].split('#')[0]
        if url_path in ('/', '/index.html', ''):
            return ADMIN_FILE
        rel = url_path.lstrip('/')
        full = os.path.realpath(os.path.join(SITE_DIR, rel))
        if not full.startswith(os.path.realpath(SITE_DIR) + os.sep) and full != os.path.realpath(SITE_DIR):
            return None
        if os.path.isdir(full):
            idx = os.path.join(full, 'index.html')
            if os.path.isfile(idx):
                return idx
            return None
        return full if os.path.isfile(full) else None

    def _serve_file(self, path: str):
        ct, _ = mimetypes.guess_type(path)
        if ct is None:
            ct = 'application/octet-stream'
        with open(path, 'rb') as f:
            data = f.read()
        self.send_response(200)
        self.send_header('Content-Type', ct)
        self.send_header('Content-Length', str(len(data)))
        self.send_header('Cache-Control', 'no-cache')
        self.send_header('X-Content-Type-Options', 'nosniff')
        self.end_headers()
        self.wfile.write(data)

    def _auth(self) -> bool:
        if self.headers.get('X-Admin-Token') != ADMIN_TOKEN:
            self.send_response(401)
            self.end_headers()
            self.wfile.write(b'unauthorized')
            return False
        return True

    def _json(self, status: int, obj: dict):
        body = json.dumps(obj).encode('utf-8')
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    # -------------------- GET --------------------
    def do_GET(self):
        path = self.path.split('?')[0]

        if path == '/admin/get':
            if not self._auth():
                return
            with open(ADMIN_FILE, 'rb') as f:
                data = f.read()
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.end_headers()
            self.wfile.write(data)
            return

        if path == '/healthz':
            self._json(200, {'ok': True, 'service': 'agentify', 'port': PORT, 'dir': SITE_DIR})
            return

        resolved = self._resolve(path)
        if not resolved:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'not found')
            return
        try:
            self._serve_file(resolved)
        except Exception as e:
            self.send_response(500)
            self.end_headers()
            self.wfile.write(f'error: {e}'.encode('utf-8'))

    # -------------------- POST --------------------
    def do_POST(self):
        path = self.path.split('?')[0]

        if path == '/admin/update':
            if not self._auth():
                return
            length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(length)
            with open(ADMIN_FILE, 'wb') as f:
                f.write(body)
            self._json(200, {'ok': True, 'action': 'full_replace', 'bytes': len(body)})
            print(f'[admin] full replace — {len(body)} bytes', flush=True)
            return

        if path == '/admin/patch':
            if not self._auth():
                return
            length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(length).decode('utf-8')
            payload = json.loads(body)
            find = payload.get('find', '')
            replace = payload.get('replace', '')
            with open(ADMIN_FILE, 'r', encoding='utf-8') as f:
                html = f.read()
            if find not in html:
                self._json(404, {'ok': False, 'error': 'find string not found in file'})
                return
            count = html.count(find)
            html = html.replace(find, replace, 1)
            with open(ADMIN_FILE, 'w', encoding='utf-8') as f:
                f.write(html)
            self._json(200, {'ok': True, 'action': 'patch', 'occurrences_found': count})
            print(f'[admin] patch — replaced 1 of {count} occurrence(s)', flush=True)
            return

        self.send_response(404)
        self.end_headers()

    def log_message(self, fmt, *args):
        sys.stdout.write(f'[{self.log_date_time_string()}] {fmt % args}\n')
        sys.stdout.flush()


if __name__ == '__main__':
    try:
        print('Agentify server starting on :%d serving %s' % (PORT, SITE_DIR), flush=True)
        print('Python: %s' % sys.version, flush=True)
        HTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
    except Exception as e:
        sys.stderr.write('FATAL: %s\n' % e)
        sys.stderr.write(traceback.format_exc())
        sys.stderr.flush()
        raise
