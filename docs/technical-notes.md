# Technical Notes

### Conceptual Architecture and Base Technology

Sublime acts as an abstract, generalized model of an HTTP request and response. It serves as the central hub in a hub-and-spoke transformation model that eliminates point-to-point data conversions. By abstracting the domain-specific formatting of network state transfer, it allows creators to focus on declarative business logic rather than writing imperative formatting flows. 

Sky Sublime extends this base model by injecting rules directly related to Sky API entities and concepts. By bridging the generic HTTP representation with the Sky ecosystem, developers can describe network operations using higher-level abstractions.

### Sky APIs and Resource Spaces

The Sky concept introduces structured API descriptions that delineate resource spaces and locators. These abstractions provide logical and programmatic handles that facilitate high-level programming both within and outside the Sublime context. 

Because the Sky model allows the software to describe full resource spaces, it provides a universal ontology for creating resource descriptions. This structured ontology offers a common vocabulary that simplifies the management of sophisticated access models, enabling support for advanced authorization structures like Runes and Web Grants directly within the request and response representations.

### Colloquial to Canonical Inference

A fundamental capability of Sky Sublime is its ability to accept a "colloquial" description of a network operation. Creators can specify a request minimally using shorthand—such as asking to create a "blog post" resource under a specific account—rather than meticulously populating a complete HTTP request.

While the base Sublime engine provides normalization, Sky Sublime possesses the benefit of the Sky API concept and resource spaces. This provides the substantial context needed to complete massive inference on your behalf. Using the Athena rules engine, Sky Sublime automatically expands the minimal colloquial representation into a canonical version perfectly suited for transfer over the wire.

### API Discovery and Caching

The expansion of colloquial requests relies on accurate metadata about the target resource spaces. Sky Sublime achieves this by utilizing `@dashkite/scout` to discover API descriptions dynamically. Scout automatically caches these descriptions, ensuring that repeated requests to the same origin efficiently utilize the cached `api.yaml` metadata without incurring redundant network overhead.
