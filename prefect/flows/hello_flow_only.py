from prefect import flow, task
from dotenv import load_dotenv

# Load .env file
load_dotenv()

@flow
def say_hello():
    print("Hello, World!")

if __name__ == "__main__":
    say_hello()