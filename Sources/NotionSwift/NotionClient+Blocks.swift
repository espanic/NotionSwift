//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

// MARK: - Blocks

extension NotionClient {

    public func blockChildren(
        blockId: Block.Identifier,
        params: BaseQueryParams,
        completed: @escaping (Result<ListResponse<ReadBlock>, NotionClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}/children",
                identifier: blockId,
                params: params.asParams
            ),
            headers: headers(),
            completed: completed
        )
    }
    
    public func blockChildren(
        blockId: Block.Identifier,
        params: BaseQueryParams
    ) async -> Result<ListResponse<ReadBlock>, NotionClientError>
    {
        await networkClient.get(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}/children",
                identifier: blockId,
                params: params.asParams
            ),
            headers: headers()
        )
    }

    public func blockAppend(
        blockId: Block.Identifier,
        children: [WriteBlock],
        completed: @escaping (Result<ListResponse<ReadBlock>, NotionClientError>) -> Void
    ) {
        networkClient.patch(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}/children",
                identifier: blockId
            ),
            body: BlockAppendRequest(children: children),
            headers: headers(),
            completed: completed
        )
    }
    
    public func blockAppend(
        blockId: Block.Identifier,
        children: [WriteBlock]
    ) async -> Result<ListResponse<ReadBlock>, NotionClientError> 
    {
        await networkClient.patch(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}/children",
                identifier: blockId
            ),
            body: BlockAppendRequest(children: children),
            headers: headers()
        )
    }

    public func blockUpdate(
        blockId: Block.Identifier,
        value: UpdateBlock,
        completed: @escaping (Result<ReadBlock, NotionClientError>) -> Void
    ) {
        networkClient.patch(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}",
                identifier: blockId
            ),
            body: value,
            headers: headers(),
            completed: completed
        )
    }
    
    public func blockUpdate(
        blockId: Block.Identifier,
        value: UpdateBlock
    ) async -> Result<ReadBlock, NotionClientError>
    {
        await networkClient.patch(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}",
                identifier: blockId
            ),
            body: value,
            headers: headers()
        )
    }

    public func blockDelete(
        blockId: Block.Identifier,
        completed: @escaping (Result<ReadBlock, NotionClientError>) -> Void
    ) {
        networkClient.delete(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}",
                identifier: blockId
            ),
            headers: headers(),
            completed: completed
        )
    }
    
    public func blockDelete(
        blockId: Block.Identifier
    ) async -> Result<ReadBlock, NotionClientError> {
        await networkClient.delete(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}",
                identifier: blockId
            ),
            headers: headers()
        )
    }
}

private struct BlockAppendRequest: Encodable {
    let children: [WriteBlock]
}
