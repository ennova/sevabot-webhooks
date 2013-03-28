Sevabot Webhooks
================

# Testing Webhooks

Start the Sinatra app with Sevabot host and port configured:

```
SEVABOT_HOST=localhost SEVABOT_PORT=5000 shotgun
```

To test a webhook, run the following command in your terminal:

**For GitHub post commits:**

```
curl -X POST --data-urlencode payload@sample-files/github-post-commit.json http://localhost:9393/github-post-commit/:chat_id/:shared_secret
```

**For Semaphore builds:**

```
curl -X POST --data @sample-files/semaphore-build.json http://localhost:9393/semaphore-build/:chat_id/:shared_secret --header "Content-Type:application/json"
```
