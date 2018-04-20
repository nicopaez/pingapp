# pingapp
Just a trivial application I used for my PoC
To run it locally just execute:

```
bundle install
bundle exec ruby app.rb
```
Then browse http://localhost:4567

## To use it with Docker

```
docker build -t pingapp:20171107.0 .
docker login
docker tag pingapp:20171107.0 nicopaez/pingapp:20171107.0
docker push nicopaez/pingapp:20171107.0
```
Then run docker run -p 4567:4567 -d pingapp:20171107.0 

## To use it with OpenShift

````
oc new-project devops-tutorial --display-name="DevOps Tutorial"
oc new-app nicopaez/pingapp
oc expose svc/pingapp
oc set env dc/pingapp CONFIG_LOCATION=/config/config.json
oc set env dc/pingapp SECRETS_LOCATION=/secrets/secrets.json
oc create configmap config-pingapp --from-file=config.json
oc create secret generic secrets-pingapp  --from-file=secrets.json
oc volume dc/pingapp --add --name=config -t configmap --configmap-name=config-pingapp -m /config
oc volume dc/pingapp --add --name=secrets -t secret --secret-name=secrets-pingapp -m /secrets
````
