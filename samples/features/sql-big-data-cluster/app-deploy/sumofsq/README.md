# Running a basic R script in SQL Server big data cluster

### Contents

[About this sample](#about-this-sample)<br/>
[Before you begin](#before-you-begin)<br/>
[Run this sample](#run-this-sample)<br/>
[Sample details](#sample-details)<br/>
[Related links](#related-links)<br/>

<a name=about-this-sample></a>

## About this sample

This is a sample [R](https://www.r-project.org/) app, which takes two whole numbers as input and returns the sum of squares (a^2 + b^2). The code for this sample is in [sum_of_squares.R](sum_of_squares.R). The inputs and outputs are shown below.

### Inputs
|Parameter|Description|
|-|-|
|`a`|The first whole number|
|`b`|The second whole number|

### Outputs
|Parameter|Description|
|-|-|
|`result`|The result of calculating a^2 + b^2|


<a name=before-you-begin></a>

## Before you begin

To run this sample, you need the following prerequisites.

**Software prerequisites:**

1. SQL Server big data cluster CTP 2.3 or later.
2. `azdata`. Refer to [installing azdata](https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-install-azdata?view=sqlallproducts-allversions) document on setting up the `azdata` and connecting to a SQL Server 2019 big data cluster.

<a name=run-this-sample></a>

## Run this sample

1. Clone or download this sample on your computer.
2. Log in to the SQL Server big data cluster using the command below using the IP address of the `mgmtproxy-svc-external` in your cluster. If you are not familiar with `mssqltctl` you can refer to the [documentation](https://docs.microsoft.com/en-us/sql/big-data-cluster/big-data-cluster-create-apps?view=sqlallproducts-allversions) and then return to this sample.

    ```bash
    azdata login -e https://<ip-address-of-mgmtproxy-svc-external>:30777 -u <user-name> -p <password>
    ```
3. Deploy the application by running the following command, specifying the folder where your `spec.yaml` and `sum_of_squares.R` files are located:
    ```bash
    azdata app create --spec ./sumofsq
    ```
4. Check the deployment by running the following command:
    ```bash
    azdata app list -n sum-of-sq -v [version]
    ```
    Once the app is listed as `Ready` you can continue to the next step.
5. Test the app by running the following command:
    ```bash
    azdata app run -n sum-of-sq -v [version] --input a=42,b=3435
    ```
    You should get output like the example below. The answer to your question are returned as `result`.
    ```json
    {
      "changedFiles": [],
      "consoleOutput": "",
      "errorMessage": "",
      "outputFiles": {},
      "outputParameters": {
        "result": 11800989.0
      },
      "success": true
    }
    ```

    > **RESTful web service**. Note that any app you create is also accessible using a RESTful web service that is [Swagger](swagger.io) compliant. See step 6 in the [Addpy sample](../addpy/README.md#restapi) for detailed instructions on how to call the web service.

6. You can clean up the sample by running the following commands:
    ```bash
    # delete app
    azdata app delete --name sum-of-sq --version [version]
    ```

<a name=sample-details></a>

## Sample details

Please refer to [sum_of_squares.R](sum_of_squares.R) for the code for this sample.

### Spec file
Here is the spec file for this application. As you can see the sample uses the `R` runtime and calls the `sofsq` method in the `sum_of_squares.R` file, accepting two integer inputs named `a` and `b` and returning an integer output named `result`.

```yaml
name: sum-of-sq
version: v1
runtime: R
src: ./sum_of_squares.R
entrypoint: sofsq
replicas: 1
poolsize: 1
inputs:
  a: integer
  b: integer
output:
  result: integer
```

<a name=related-links></a>

## Related Links
For more information, see these articles:

[How to deploy and app on SQL Server 2019 big data cluster (preview)](https://docs.microsoft.com/en-us/sql/big-data-cluster/big-data-cluster-create-apps?view=sqlallproducts-allversions)