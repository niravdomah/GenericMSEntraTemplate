# User Management with Microsoft Entra SSO Authentication

## What is this module for?

This module sets up User Management with Microsoft Entra SSO authentication using session tokens. It provides login, logout, and user info endpoints, and integrates with Stadium 8 via a session cookie that can be used to authenticate against all other endpoints in your solution.

## How do I get set up?

+ **Prerequisites:**

    + SQL Server: 2022
    + Linx: 6.13.0
    + Request Application to be added by Infrastructure using the instructions [here](MicrosoftApplicationSetupForLogin.pdf)
        + Ask for the callback URL to be: http://localhost:10010/v1/auth/callback
            + They should provide a ClientId, TenantId and ClientSecret (to be used in the Linx Settings)


+ **Database Setup:**

    + Open **SSMS** on your local machine
        + Login using **Windows Authentication**
            + Open the `Security` folder in the Object Explorer (below the `Databases` folder, at the same level)
                + Open the `Logins` folder, then right click on `NT AUTHORITY\SYSTEM` and click `Properties`
                    + Under the `Server Roles` page, make sure `sysadmin` is checked, then click `OK`

    + Open the **Database Updater Tool** and set the properties as follows:

        | **Property** | **Value** |
        |---|---|
        | SQL Update Scripts Folder | `C:\Temp\TempLinxStorage\SSOChanges\GenericMSEntraTemplate\Src\Db` (or update to where scripts are stored) |
        | Server | `SQL2022` (or update to your local server name) |
        | Database | **UserManagement** |
        | Authentication | Windows |
        | Script Log Table | UpdateScriptLog |

    + Click **Install Database**

    + Run the following script to update the default user details to your own:
        ```sql
        UPDATE UserManagement.[User]
        SET FirstName = '{YourFirstName}',
            LastName  = '{YourLastName}',
            Email     = '{YourDigiataEmail}';
        ```

+ **Linx Solution Configuration:**

    + Open the Linx solution and configure the following Settings:

        | **Setting** | **Description** |
        |---|---|
        | `AuthenticationBaseUri` | URL of the Authentication BFF API |
        | `CallbackUri` | URL to provide to IT for Microsoft app setup — should link to the `AuthExchangeCode` endpoint on the authentication API |
        | `ClientErrorUri` | Link to the Unauthorized page on your Stadium 8 application (used when login fails) |
        | `ClientRedirectUri` | Link to redirect to after a successful login (usually the landing page of the Stadium 8 application) |
        | `CORSOrigins` | Restricts session token usage to specified hosts — include all base URLs (host and port) of every API in your solution |
        | `EntraCodeVerifier` | Used for Code Challenge Hash generation |
        | `JwtSecret` | Used to generate the encrypted JWT session token |
        | `MicrosoftClientId` | Obtain from IT after they have set up the application on the Microsoft side |
        | `MicrosoftClientSecret` | Obtain from IT after they have set up the application on the Microsoft side |
        | `MicrosoftLoginUri` | Template for the Microsoft login URL used to redirect users for login |
        | `MicrosoftTenantId` | Obtain from IT after they have set up the application on the Microsoft side |
        | `UserManagementApiUri` | Base URI of the User Management API |

+ **Deployment:**

    + Deploy the Linx solution to the Linx Server
    + Switch **all services on**

## How do I use this module?

+ **Test the Login Flow:**

    + Open a fresh browser tab and navigate to:
        ```
        http://localhost:10010/v1/auth/login
        ```
        + This will redirect you to the Microsoft login page
            + Log in with your Microsoft (Digiata) credentials
                + **Success:** You will be redirected to the `ClientRedirectUri` Linx Setting
                + **Failure:** You will be redirected to the `ClientErrorUri` Linx Setting

+ **Verify the Session Token:**

    + Once logged in, a session token is stored in your browser cookie
    + Navigate to the Authentication Swagger page:
        ```
        http://localhost:10010/swagger
        ```
    + Click the **GET /v1/auth/userinfo** endpoint → **Try it out** → **Execute**
        + The response will return the user's information, including assigned roles and accessible pages
        + Stadium 8 should use this endpoint to determine what the user has access to within the application

+ **Accessing the User ID:**

    + Once logged in, the `UserId` is available on every API call via:
        ```
        @{$.Parameters.HttpContext.User.Name}
        ```
        + This is useful for user-specific data filtering across all endpoints

+ **User Management Swagger:**

    + Navigate to:
        ```
        http://localhost:10011/user-management/swagger
        ```
    + The session cookie will authenticate all calls — for example, click **GET /v1/users** → **Try it out** → **Execute**

+ **Logging Out:**

    + Navigate to:
        ```
        http://localhost:10010/swagger
        ```
    + Execute the **POST /v1/auth/logout** endpoint to log the user out and remove the session

## Adding Session Cookie Authentication to Other APIs

+ Ensure the **Security Schemes** and **Security** setup in the API definition matches the User Management API example
+ Add the new API's host and port to the `CORSOrigins` Linx Setting
+ On your **RESTHost** setup in Linx, link the `CORSOrigins` Setting to the **CORS Origin** property
+ Ensure the **Authenticate** event is checked and use the `OnAuthenticate` function on the `OperationEvents_Authenticate` endpoint
    + You can copy this directly from the User Management API example
