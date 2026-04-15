from requests import request

class EpcRequests:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    @staticmethod
    def request(self, method: str, url: str, json=None):
        response = request(method, url, json=json)
        return response
