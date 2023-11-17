from flask import Flask, request, jsonify, render_template
import psycopg2

app = Flask(__name__)

# PostgreSQL connection parameters
db_params = {
    'dbname': 'db_name',
    'user': 'de_user',
    'password': 'db_password',
    'host': 'db_host',
    'port': 'db_port'
}

@app.route('/')
def index():
    # Fetch and display the unique visitor count
    visitor_count = get_visitor_count()
    return render_template('index.html', visitor_count=visitor_count)

def get_visitor_count():
    # Connect to the PostgreSQL database
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    # Capture the visitor's IP address
    visitor_ip = request.remote_addr

    # Insert the visitor's IP address into the database
    cur.execute("INSERT INTO visitors (ip_address) VALUES (%s);", (visitor_ip,))
    conn.commit()

    # Count the number of unique visitors
    cur.execute("SELECT COUNT(DISTINCT ip_address) FROM visitors;")
    visitor_count = cur.fetchone()[0]

    # Close the database connection
    cur.close()
    conn.close()

    return visitor_count

# Route for /version endpoint
@app.route('/version')
def get_version():
    version_info = {
        'app_name': 'Yens Website',
        'version': '1.0',
        'status': 'stable'
    }
    return jsonify(version_info)

if __name__ == '__main__':
    app.run(debug=True)