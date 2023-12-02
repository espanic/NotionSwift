//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

// MARK: - Databases

extension NotionClient {
    public func database(
        databaseId: Database.Identifier,
        completed: @escaping (Result<Database, NotionClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(
                path: "/v1/databases/{identifier}",
                identifier: databaseId
            ),
            headers: headers(),
            completed: completed
        )
    }
    
    public func database(
        databaseId: Database.Identifier
    ) async -> Result<Database, NotionClientError> 
    {
        await networkClient.get(
            urlBuilder.url(
                path: "/v1/databases/{identifier}",
                identifier: databaseId
            ),
            headers: headers()
        )
    }

    public func databaseQuery(
        databaseId: Database.Identifier,
        params: DatabaseQueryParams,
        completed: @escaping (Result<ListResponse<Page>, NotionClientError>) -> Void
    ) {
        networkClient.post(
            urlBuilder.url(
                path: "/v1/databases/{identifier}/query",
                identifier: databaseId
            ),
            body: params,
            headers: headers(),
            completed: completed
        )
    }
    
    public func databaseQuery(
        databaseId: Database.Identifier,
        params: DatabaseQueryParams
    ) async -> Result<ListResponse<Page>, NotionClientError> {
        await networkClient.post(
            urlBuilder.url(
                path: "/v1/databases/{identifier}/query",
                identifier: databaseId
            ),
            body: params,
            headers: headers()
        )
    }

    public func databaseCreate(
        request: DatabaseCreateRequest,
        completed: @escaping (Result<Database, NotionClientError>) -> Void
    ) {
        networkClient.post(
            urlBuilder.url(
                path: "/v1/databases"
            ),
            body: request,
            headers: headers(),
            completed: completed
        )
    }
    
    public func databaseCreate(
        request: DatabaseCreateRequest
    ) async -> Result<Database, NotionClientError> {
        await networkClient.post(
            urlBuilder.url(
                path: "/v1/databases"
            ),
            body: request,
            headers: headers()
        )
    }

    public func databaseUpdate(
        databaseId: Database.Identifier,
        request: DatabaseUpdateRequest,
        completed: @escaping (Result<Database, NotionClientError>) -> Void
    ) {
        networkClient.patch(
            urlBuilder.url(
                path: "/v1/databases/{identifier}",
                identifier: databaseId
            ),
            body: request,
            headers: headers(),
            completed: completed
        )
    }
    
    public func databaseUpdate(
        databaseId: Database.Identifier,
        request: DatabaseUpdateRequest
    ) async -> Result<Database, NotionClientError>{
        await networkClient.patch(
            urlBuilder.url(
                path: "/v1/databases/{identifier}",
                identifier: databaseId
            ),
            body: request,
            headers: headers()
        )
    }
}
