# NetworkFoundation

NetworkFoundation is a robust networking framework for Swift that provides a solid foundation for building strong network communication in your applications. It offers comprehensive tools and abstractions to simplify common networking tasks and streamline your code.

## Getting Started

To start using NetworkFoundation in your project, follow these steps:

Add the NetworkFoundation package to your project using Swift Package Manager.
Import the NetworkFoundation module into your source files.
Create a router conforming to the RouterProtocol protocol to define your network requests.
Implement the required methods and properties in your router.
Use the asURLRequest() method to obtain a URLRequest object for your network request.
Make the request using URLSession or any other networking library of your choice.

## Requirements

* Swift 5.0+
* iOS 13.0+

## Contributing

Contributions to NetworkFoundation are welcome! If you find a bug or have an idea for an improvement, please open an issue or submit a pull request.

## License

NetworkFoundation is released under the MIT License.


## Wiki

### Network Repository:
A network repository is a component responsible for abstracting the details of data retrieval and storage related to network operations. It encapsulates the logic for making network requests, handling responses, and potentially managing data caching. The network repository is an intermediary between the higher-level application code (view models or presenters) and the network service. It provides a clean interface for fetching and manipulating data from remote APIs, making it easier to manage network-related concerns and keep them separate from the rest of the application.

### Network Service:
A network service, or API service, handles communication with external APIs or services over the network. It typically includes methods for making HTTP requests, handling authentication, setting headers, encoding and decoding data, and handling errors. The network service abstracts away the low-level networking details, making it easier for other application parts to interact with external resources. It can provide a layer of consistency and reusability for network-related tasks.

### Network Router (Endpoint Router):
A network router, often referred to as an endpoint router or API router, is a pattern used to define and manage various API endpoints and their associated configurations in a structured manner. Similar to the routing in web applications, a network router defines different cases for each API endpoint, including the HTTP method, URL, headers, and parameters. It encapsulates the specifics of constructing a URLRequest for each endpoint, making the networking code more organized and maintainable. The router abstracts the endpoint details away from the rest of the application and provides a centralized place to manage API interactions.

In summary, the network repository abstracts data retrieval and storage related to network operations, the network service handles the actual networking tasks, and the network router organizes and defines the configurations for different API endpoints. Separating these components helps maintain a clear structure in your networking code and simplifies the management of networking-related concerns.


