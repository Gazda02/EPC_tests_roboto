from requests import request

class EpcRequests:
    ROBOT_LIBRARY_SCOPE = 'EPC-REQUESTS'

    def __init__(self):
        self.url = 'http://127.0.0.1:8000/'

    def test_epc_connection(self) -> int:
        response = request('GET', self.url)
        return response.status_code