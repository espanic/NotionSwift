//
//  Created by Wojciech Chojnacki on 06/06/2021.
//

import Foundation

public protocol NotionClientType: AnyObject {

    // MARK: - block

    func blockChildren(
        blockId: Block.Identifier,
        params: BaseQueryParams,
        completed: @escaping (Result<ListResponse<ReadBlock>, NotionClientError>) -> Void
    )
    
    func blockChildren(
        blockId: Block.Identifier,
        params: BaseQueryParams
    ) async -> Result<ListResponse<ReadBlock>, NotionClientError>

    func blockAppend(
        blockId: Block.Identifier,
        children: [WriteBlock],
        completed: @escaping (Result<ListResponse<ReadBlock>, NotionClientError>) -> Void
    )
    
    func blockAppend(
        blockId: Block.Identifier,
        children: [WriteBlock]
    ) async -> Result<ListResponse<ReadBlock>, NotionClientError>

    func blockUpdate(
        blockId: Block.Identifier,
        value: UpdateBlock,
        completed: @escaping (Result<ReadBlock, NotionClientError>) -> Void
    )
    
    func blockUpdate(
        blockId: Block.Identifier,
        value: UpdateBlock
    ) async -> Result<ReadBlock, NotionClientError>

    func blockDelete(
        blockId: Block.Identifier,
        completed: @escaping (Result<ReadBlock, NotionClientError>) -> Void
    )
    
    func blockDelete(
        blockId: Block.Identifier
    ) async -> Result<ReadBlock, NotionClientError>

    // MARK: - database

    func database(
        databaseId: Database.Identifier,
        completed: @escaping (Result<Database, NotionClientError>) -> Void
    )
    
    func database(
        databaseId: Database.Identifier
    ) async -> Result<Database, NotionClientError>
    
    func databaseQuery(
        databaseId: Database.Identifier,
        params: DatabaseQueryParams,
        completed: @escaping (Result<ListResponse<Page>, NotionClientError>) -> Void
    )
    
    func databaseQuery(
        databaseId: Database.Identifier,
        params: DatabaseQueryParams
    ) async -> Result<ListResponse<Page>, NotionClientError>

    func databaseCreate(
        request: DatabaseCreateRequest,
        completed: @escaping (Result<Database, NotionClientError>) -> Void
    )
    
    func databaseCreate(
        request: DatabaseCreateRequest
    ) async -> Result<Database, NotionClientError>

    func databaseUpdate(
        databaseId: Database.Identifier,
        request: DatabaseUpdateRequest,
        completed: @escaping (Result<Database, NotionClientError>) -> Void
    )
    
    func databaseUpdate(
        databaseId: Database.Identifier,
        request: DatabaseUpdateRequest
    ) async -> Result<Database, NotionClientError>

    // MARK: - page

    func page(
        pageId: Page.Identifier,
        completed: @escaping (Result<Page, NotionClientError>) -> Void
    )
    
    func page(
        pageId: Page.Identifier
    ) async -> Result<Page, NotionClientError>

    func pageCreate(
        request: PageCreateRequest,
        completed: @escaping (Result<Page, NotionClientError>) -> Void
    )
    
    func pageCreate(
        request: PageCreateRequest
    ) async -> Result<Page, NotionClientError>

    func pageUpdateProperties(
        pageId: Page.Identifier,
        request: PageProperiesUpdateRequest,
        completed: @escaping (Result<Page, NotionClientError>) -> Void
    )
    
    func pageUpdateProperties(
        pageId: Page.Identifier,
        request: PageProperiesUpdateRequest
    ) async -> Result<Page, NotionClientError>

    // MARK: - user

    func user(
        userId: User.Identifier,
        completed: @escaping (Result<User, NotionClientError>) -> Void
    )
    
    func user(
        userId: User.Identifier
    ) async -> Result<User, NotionClientError>

    func usersList(
        params: BaseQueryParams,
        completed: @escaping (Result<ListResponse<User>, NotionClientError>) -> Void
    )
    
    func usersList(
        params: BaseQueryParams
    ) async -> Result<ListResponse<User>, NotionClientError>

    func usersMe(
        completed: @escaping (Result<User, NotionClientError>) -> Void
    )
    
    func usersMe() async -> Result<User, NotionClientError>

    // MARK: - search
    
    func search(
        request: SearchRequest,
        completed: @escaping (Result<SearchResponse, NotionClientError>) -> Void
    )
    
    func search(
        request: SearchRequest
    ) async -> Result<SearchResponse, NotionClientError>
}

// MARK: - default arguments

extension NotionClientType {

    public func blockChildren(
        blockId: Block.Identifier,
        completed: @escaping (Result<ListResponse<ReadBlock>, NotionClientError>) -> Void
    ) {
        self.blockChildren(blockId: blockId, params: .init(), completed: completed)
    }
    
    public func blockChildren(
        blockId: Block.Identifier
    ) async -> Result<ListResponse<ReadBlock>, NotionClientError>
    {
        await self.blockChildren(blockId: blockId, params: .init())
    }
    

    public func databaseQuery(
        databaseId: Database.Identifier,
        completed: @escaping (Result<ListResponse<Page>, NotionClientError>) -> Void
    ) {
        self.databaseQuery(databaseId: databaseId, params: .init(), completed: completed)
    }
    
    public func databaseQuery(
        databaseId: Database.Identifier
    ) async -> Result<ListResponse<Page>, NotionClientError> {
        await self.databaseQuery(databaseId: databaseId, params: .init())
    }

    public func usersList() async -> Result<ListResponse<User>, NotionClientError> {
        await self.usersList(params: .init())
    }

    public func search() async -> Result<SearchResponse, NotionClientError>
    {
        await self.search(request: .init())
    }
}
