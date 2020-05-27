from locust import HttpLocust, TaskSet, between


def index(l):
    l.client.get("/")


def world_stats(l):
    l.client.get("/world-stats")


class UserBehavior(TaskSet):
    tasks = {index: 1, world_stats: 1}


class WebsiteUser(HttpLocust):
    host = "http://127.0.0.1:8081"
    task_set = UserBehavior
    wait_time = between(5.0, 9.0)
