from fastapi import WebSocket
from typing import Dict, List


class ConnectionManager:
    def __init__(self):
        # role -> list of active websocket connections
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, role: str):
        await websocket.accept()
        if role not in self.active_connections:
            self.active_connections[role] = []
        self.active_connections[role].append(websocket)

    def disconnect(self, websocket: WebSocket, role: str):
        if role in self.active_connections:
            if websocket in self.active_connections[role]:
                self.active_connections[role].remove(websocket)

    async def send_to_role(self, role: str, message: dict):
        # target_role == "all" ke connections + specific role ke connections
        connections = self.active_connections.get(role, []) + self.active_connections.get("all", [])
        for connection in connections:
            try:
                await connection.send_json(message)
            except Exception:
                pass


manager = ConnectionManager()