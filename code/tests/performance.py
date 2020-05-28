from locust import HttpUser, task, between


class WebsiteUser(HttpUser):
    wait_time = between(5.0, 9.0)

    @task
    def endpoint_index(self):
        self.client.get("/")

    @task(3)
    def endpoint_world_stats(self):
        self.client.get("/world-stats")
