# Node.js custom plugin template walkthrough
This walkthrough will help you to learn how to use a Node.js microservice from scratch. 

In order to do so, access to [Mia-Platform DevOps Console](https://console.cloud.mia-platform.eu/login), create a new project and go to the **Design** area. From the Design area of your project select "Microservices" on the menu on the left sidebar and then create a new microservice, you have now reached [Mia-Platform Marketplace](https://docs.mia-platform.eu/development_suite/api-console/api-design/marketplace/)! <br />
In the marketplace you will see a set of Examples and Templates that can be used to set-up microservices with a predefined and tested function. 

For this walkthrough select the following template: **Node.js template**. After clicking on this template you will be asked to give the following information:

- Name (Internal Hostname)
- GitLab Group Name
- GitLab Repository Name
- Docker Image Name
- Description (optional)

You can read more about this fields in [Manage your Microservices from the Dev Console](https://docs.mia-platform.eu/development_suite/api-console/api-design/services/) section of Mia-Platform documentation.

Give to your microservice the following Name: **template-microservice**. Then, fill the other required fields and confirm that you want to create a microservice. Now we have generated a *template-microservice* repository that is already deployed on Mia-Platform [Nexus Repository Manager](https://nexus.mia-platform.eu/).

It is important to know that the microservice that we have just created is not saved yet on the DevOps Console. It is not essential to save the changes that we have made, since we will later make other modifications inside of our project in the DevOps Console.<br />
If you decide to save your changes now remember to choose a meaningful title for your commit (e.g "template-microservice_creation"). After some seconds you will be prompted with a popup message which confirms that you have successfully saved all your changes.<br />
A more detailed description on how to create and save a Microservice can be found in [Microservice from template - Get started](https://docs.mia-platform.eu/development_suite/api-console/api-design/custom_microservice_get_started/) section of Mia-Platform documentation.

After having created your first microservice (based on *Node.js template*) you will be able to access to its git repository ( this functionality is present only in microservices created from Examples and Templates). Inside this repository you will find an [index.js](https://github.com/mia-platform-marketplace/Node.js-Custom-Plugin-Template/blob/master/index.js) file with the following lines of code:
```js
/* eslint require-await: 0 */
'use strict'

const customService = require('@mia-platform/custom-plugin-lib')()
/* eslint-disable-next-line no-unused-vars */
module.exports = customService(async function index(service) {

  /*
   * Insert your code here.
   */

})
```
`custom-plugin-lib` is a library developed in [node.js](https://github.com/mia-platform/custom-plugin-lib), based on the [fastify](https://fastify.io) library. It contains configurations and functions useful for the project. We will now add a new route that, when visited, will print an hello message and return the http response status. To do so, let's use the following function:
`service.addRawCustomPlugin(httpVerb, path, handler, schema)` 
<br />
to which we will pass the following parameters:
* `httpVerb`: *GET*, the HTTP verb of the request.
* `path`: */hello*, the route that gives us access to the logics described in our new handler.
* `handler`: *helloHandler*, function that contains the actual behavior. It must respect the same interface defined in the documentation of the handlers of fastify.
* `schema`: *helloSchema* , definition of the request and response data schema. The format is the one accepted by fastify.

A more detailed description on how to use our `custom-plugin-lib` to define the behavior of your microservice in response to an HTTP request can be found in [Create a Node Custom Microservices](https://docs.mia-platform.eu/development_suite/api-console/api-design/plugin_baas_4/) section of Mia-Platform documentation.

In order to proceed, we need to define a handler, a schema and pass them as parameters to this function.<br />
Below, you can see how the *index.js* file will look like after having defined all the parameters required by `service.addRawCustomPlugin` function:
```js
/* eslint require-await: 0 */
'use strict'

// handler scheme
async function helloHandler() {
  const helloMessage = `Hello World`
  return {
    status: 200,
    message: helloMessage,
  }
}

// response scheme
const helloSchema = {
  response: {
    200: {
      type: 'object',
      properties: {
        status: { type: 'number' },
        message: { type: 'string' },
      },
    },
  },
}

// wiring e route declaration
const customService = require('@mia-platform/custom-plugin-lib')()
/* eslint-disable-next-line no-unused-vars */
module.exports = customService(async function index(service) {
  service.addRawCustomPlugin('GET', '/hello', helloHandler, helloSchema)
})
```
Searching for the defined route: **/hello** through a **GET** request, we will execute the **hellolHandler**. Thanks to its execution, we obtain a response structured as **helloSchema**:  

200 with<br />
status: 200,<br />
message: 'Hello World'.

After commiting these changes to your repository, we can go back to Mia Platform DevOps Console.

In order to access to our new microservice it is necessary to create an endpoint to it. Step 3 of [Microservice from template - Get started](https://docs.mia-platform.eu/development_suite/api-console/api-design/custom_microservice_get_started/) section of Mia-Platform documentation will explain in detail how to create an endpoint from the DevOps Console.

In particular, in this walkthrough we will create an endpoint to our *template-microservice*. To do so, from the Design area of your project select "Endpoints" on the menu on the left sidebar and then create a new endpoint.<br />
Now we need to choose a path for our endpoint and to connect this endpoint to our microservice. Give to your endpoint the following path: **say-hello**. Then, specify that you want to connect your endpoint to a microservice and, finally, select *template-microservice*.

After having created an endpoint to your microservice you should save the changes that you have done to your project in the DevOps console, in a similar way to what we have previously done after the microservice creation.

Once all the changes that we have made are saved, we are now able to deploy our project through the API Console. Go to the **Deploy** area of the DevOps Console.<br />
Once here select the environment and the branch you have worked on. When the deploy process is finished you will receveive a pop-up message that will inform you.<br />
Step 5 of [Microservice from template - Get started](https://docs.mia-platform.eu/development_suite/api-console/api-design/custom_microservice_get_started/) section of Mia-Platform documentation will explain in detail how to correctly deploy your project.

Now, if you launch the following command on your terminal:

`curl <YOUR_PROJECT_HOST>/say-hello/hello`

(remember to replace `<YOUR_PROJECT_HOST>` with the real host of your project)<br />
you should see the following message: 

`{"status":200,"message":"Hello World"}`

Congratulations! You have successfully learnt how to modify a blank template into an hello-world node.js microservice!

