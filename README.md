# SyHD: Syntax hessischer Dialekte

This is wrapper container for SyHD


## Deployment on ACDH-CH servers

Deployment on ACDH-CH k8s cluster is performed over Github actions.

### Environment variables and secrets

| Environment Variable    | Required | Default                                                               | Description                                              |
|-------------------------|----------|-----------------------------------------------------------------------|----------------------------------------------------------|
| HELM_UPGRADE_EXTRA_ARGS |    +     | --set 'ingress.annotations.cert-manager\.io/cluster-issuer=acdh-prod' | Ingress annotation needed for genrating ssl certificate. |
| KUBE_NAMESPACE          |    +     |                                                                       | Specifies the k8s namespace for the workload.            |
| PUBLIC_URL              |    +     |                                                                       | The domain under which service will work.                |
| SERVICE_ID              |    +     |                                                                       | The ID of the Redmine service issue.                     |


| Environment Secrets          | Required | Default | Description |
|------------------------------|----------|---------|------------------------------------|
| K8S_SECRET_TYPO3_DB_HOST     |    +     |         | The host that will serve database. |
| K8S_SECRET_TYPO3_DB_NAME     |    +     |         | The name of the database.          |
| K8S_SECRET_TYPO3_DB_PASSWORD |    +     |         | The database password.             |
| K8S_SECRET_TYPO3_DB_USER     |    +     |         | The database password.             |

### Data persistency

Following directories should be persistent:
 - /var/www/html

Persistent directory should be owned by UID:GID: 33:33 (www-data)

Data is copied from syhd-august2023 
The database dump is restored from file shyd_pg15_2023-08-19.backup 

Data is provided by Robert Engsterhold over https://hessenbox.uni-marburg.de


