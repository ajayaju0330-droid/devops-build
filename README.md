# DevOps Build - Project 3: Application Deployment

A React production build served by nginx on port 80, containerised with Docker and deployed to AWS EC2 through a Jenkins CI/CD pipeline, with health monitoring.

## Submission details
- **GitHub repo:** https://github.com/ajayaju0330-droid/devops-build
- **Deployed site:** http://54.147.57.17
- **Docker images:** `ajayrag/dev` (public) and `ajayrag/prod` (private)

## Architecture
- **Jenkins host:** EC2 t2.medium (Jenkins, Docker, Uptime Kuma)
- **App server:** EC2 t2.micro (runs the application container on port 80)
- **Pipeline:** GitHub push -> webhook -> Jenkins multibranch pipeline -> build image -> push to Docker Hub -> SSH deploy to app server

## Files
- `Dockerfile` - nginx:alpine serving the `build/` folder on port 80
- `docker-compose.yml` - runs the image on port 80
- `build.sh` - builds the image (`./build.sh <image> <tag>`)
- `deploy.sh` - pulls the image and runs it on the server (`./deploy.sh <image> <tag>`)
- `Jenkinsfile` - pipeline definition
- `.gitignore` / `.dockerignore` - ignore files

## Branch workflow
- Push to `dev` -> Jenkins builds and pushes the image to the **dev** Docker Hub repo, then deploys it.
- Merge `dev` into `master` -> Jenkins builds and pushes the image to the **prod** (private) Docker Hub repo, then deploys it.
- Both triggers fire automatically through a GitHub webhook.

## AWS security groups
**app-server-sg** (t2.micro)
- HTTP 80 from anywhere, so anyone with the IP can open the app
- SSH 22 from my IP only
- SSH 22 from the Jenkins host's security group only, so Jenkins can deploy; SSH is not open to the internet

**Jenkins host**
- Jenkins 8080 open to the internet (GitHub webhook needs to reach it), Uptime Kuma 3001 from my IP only, SSH 22 as configured at launch

## Monitoring
Uptime Kuma (open source) checks the site over HTTP every 30 seconds and sends an email alert through Gmail SMTP only when the app goes down (and a recovery email when it is back).

## Screenshots
| # | File | Shows |
|---|------|-------|
| 1 | screenshots/01-ssh-login.png | SSH login to the Jenkins host |
| 2 | screenshots/02-jenkins-login.png | Jenkins login page |
| 3 | screenshots/03-jenkins-configuration.png | Jenkins pipeline configuration |
| 4-6 | screenshots/04-jenkins-dev-console-build.png, 05-...-push.png, 06-...-deploy.png | Jenkins dev build: execute step commands |
| 7 | screenshots/07-jenkins-master-console-push-prod.png | Jenkins master build pushing to prod |
| 8 | screenshots/08-aws-ec2-console.png | AWS EC2 console |
| 9 | screenshots/09-aws-app-server-sg.png | Security group configuration |
| 10 | screenshots/10-dockerhub-dev-tags.png | Docker Hub dev repo with tags |
| 11 | screenshots/11-dockerhub-prod-tags.png | Docker Hub prod repo with tags |
| 12 | screenshots/12-deployed-site.png | Deployed site |
| 13 | screenshots/13-monitoring-health-status.png | Monitoring health check status |
