from locust import HttpLocust, TaskSet, between


def index(l):
    l.client.get("/asd")


class UserBehavior(TaskSet):
    tasks = {index: 1}


class WebsiteUser(HttpLocust):
    host = "http://127.0.0.1:8080"
    task_set = UserBehavior
    wait_time = between(5.0, 9.0)
