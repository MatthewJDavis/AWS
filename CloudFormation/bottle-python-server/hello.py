from cherrypy import wsgiserver
from bottle import route, run, template
import bottle

app = application = bottle.Bottle()

@app.route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)


server = wsgiserver.CherryPyWSGIServer(('0.0.0.0', 8080),
               app, server_name='www.example.com')

if __name__ == '__main__':
    try:
       server.start()
    except KeyboardInterrupt:
       server.stop()
