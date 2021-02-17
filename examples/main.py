import json

import typer
import uvicorn
from fastapi import FastAPI, Request

api = FastAPI()


@api.get("/")
def homepage(request: Request):
    user_info = request.headers.get("X-CDSDASHBOARDS-JH-USER", None)
    if user_info:
        user_info = json.loads(user_info)
    return user_info


def main(
        root_path: str = typer.Option(...),
        port: int = typer.Option(...),
):
    uvicorn.run(api, host="0.0.0.0", root_path=root_path, port=port, access_log=True)


if __name__ == "__main__":
    typer.run(main)
