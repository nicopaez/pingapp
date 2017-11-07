# pingapp
Just a trivial application I used for my PoC
To run it just execute:

```
bundle install
bundle exec ruby app.rb
```
Then browse http://localhost:4567

## To work with Docker

```
docker build -t pingapp:20171107.0 .
docker login
docker tag pingapp:20171107.0 nicopaez/pingapp:20171107.0
docker push nicopaez/pingapp:20171107.0
```

Then run docker run -p 4567:4567 -d pingapp:20171107.0 
