# Scorecard application demo for AWS

This repository is a codebase which demonstrates application scorecard and risk-based pricing concept.

## Docker install ##

1. Get application source code:
```bash
git clone https://github.com/antonvais/scorecard_application_app.git
cd scorecard_application_app/
```

2. Build docker image:
```bash
docker build --rm --force-rm -t scorecard_application_app .
```

3. Run docker image:
```bash
docker run --rm -p 3838:3838 scorecard_application_app
```

4. Open your favorite browser and navigate to the `http://127.0.0.1:3838/scorecard_application_app/`
