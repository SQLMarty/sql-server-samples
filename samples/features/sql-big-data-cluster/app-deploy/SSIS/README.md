# Scheduling a SQL Server Integration Services package in SQL Server big data cluster

### Contents

[About this sample](#about-this-sample)<br/>
[Before you begin](#before-you-begin)<br/>
[Run this sample](#run-this-sample)<br/>
[Sample details](#sample-details)<br/>
[Related links](#related-links)<br/>

<a name=about-this-sample></a>

## About this sample

This is a sample [SQL Server Integration Services (SSIS)](https://docs.microsoft.com/en-us/sql/integration-services/sql-server-integration-services?view=sql-server-2017) app, which shows how to run a SSIS package as a scheduled service. This sample creates an app that is called each minute that executes an SSIS package. The SSIS package creates a backup of the `DWConfiguration` database on the master SQL instance to disk. Also, the package cleans any backup files for the `DWConfiguration` database that are older than one hour, making sure that maximum 60 backup files will be on disk at any moment.

Refer to [installing mssqlctl](https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-install-mssqlctl?view=sqlallproducts-allversions) document on setting up the mssqlctl and connecting to a Aris cluster.

<a name=before-you-begin></a>

## Before you begin

To run this sample, you need the following prerequisites.

**Software prerequisites:**

1.SQL Server big data cluster - CTP 2.3 or later.
2. Optional: to see the SSIS package itself, install Visual Studio 2017 if you don't have it already. After that download and install [SSDT](https://docs.microsoft.com/en-us/sql/ssdt/download-sql-server-data-tools-ssdt?view=sql-server-2017#ssdt-for-vs-2017-standalone-installer). 
3. Optional: install [SSMS](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017) if it is not already installed.

<a name=run-this-sample></a>

## Run this sample

1. Clone or download this sample on your computer.
2. Log in to the SQL Server big data cluster using the command below using the IP address of the `endpoint-service-proxy` in your cluster. If you are not familiar with `mssqltctl` you can refer to the [documentation](https://docs.microsoft.com/en-us/sql/big-data-cluster/big-data-cluster-create-apps?view=sqlallproducts-allversions) and then return to this sample.

    ```bash
    mssqlctl login -e https://<ip-address-of-endpoint-service-proxy>:30777 -u <user-name> -p <password>
    ```
3. Replace `[SA_PASSWORD]` in the `spec.yaml` file with the password for SQL user `sa`.
4. Deploy the application by running the following command, specifying the folder where your `spec.yaml` and `back-up-db.dtsx` files are located:
    ```bash
    mssqlctl app create --spec ./SSIS
    ```
5. Test the deployment by running the following command:
    ```bash
    mssqlctl app list
    ```
    Once the app is listed as `Ready` the job should run within a minute.
    You can check if the backup is created by running:
    ```bash
    kubectl -n [your namespace] exec -it mssql-master-pool-0 -c mssql-server -- /bin/bash -c "ls /var/opt/mssql/data/*.DWConfigbak"
    ```
    You should see a backup being created for every run of the job, with a maximum of 60 backups since the SSIS package cleans up backups older than one hour.
    You can use any of the `.DWConfigbak` files to restore the database.
6. You can clean up the sample by running the following commands:
    ```bash
    # delete app
    mssqlctl app delete --name back-up-db --version v1
    # delete backup files
    kubectl -n [your namespace] exec -it mssql-master-pool-0 -c mssql-server -- /bin/bash -c "rm /var/opt/mssql/data/*.DWConfigbak"
    ```

<a name=sample-details></a>

## Sample details

### What is in the `spec.yaml` file

Apart from regular settings, the `spec.yaml` file in this example specifies `options` and `schedule`:

|Setting|Description|
|-|-|
|options|Specifies any command line parameters passed to the execution of the SSIS package|
|schedule|Specifies when the job should run. This follows cron expressions. A value of '*/1 * * * *' means the job runs *every minute*.|

<a name=related-links></a>

## Related Links
For more information, see these articles:

[How to deploy and app on SQL Server 2019 big data cluster (preview)](https://docs.microsoft.com/en-us/sql/big-data-cluster/big-data-cluster-create-apps?view=sqlallproducts-allversions)