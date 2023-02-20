from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

# API endpoint for getting the current agent_config.yaml file
@app.route('/agent_config', methods=['GET'])
def get_agent_config():
    try:
        output = subprocess.check_output(['cat', 'agent_config.yaml'])
        return jsonify({'status': 'success', 'data': output.decode('utf-8')})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})

# API endpoint for adding a new receiver
@app.route('/add_receiver', methods=['POST'])
def add_receiver():
    receiver_name = request.json['receiver_name']
    receiver_config = request.json['receiver_config']
    try:
        subprocess.check_output(['yq', 'w', '-i', 'agent_config.yaml', 'receivers.' + receiver_name, receiver_config])
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})

# API endpoint for updating a receiver
@app.route('/update_receiver', methods=['POST'])
def update_receiver():
    receiver_name = request.json['receiver_name']
    receiver_config = request.json['receiver_config']
    try:
        subprocess.check_output(['yq', 'w', '-i', 'agent_config.yaml', 'receivers.' + receiver_name, receiver_config])
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})

# API endpoint for deleting a receiver
@app.route('/delete_receiver', methods=['POST'])
def delete_receiver():
    receiver_name = request.json['receiver_name']
    try:
        subprocess.check_output(['yq', 'd', '-i', 'agent_config.yaml', 'receivers.' + receiver_name])
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
