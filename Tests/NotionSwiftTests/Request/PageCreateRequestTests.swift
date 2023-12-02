//
//  Created by Wojciech Chojnacki on 02/06/2021.
//

import Foundation

import XCTest
@testable import NotionSwift

// swiftlint:disable line_length
final class PageCreateRequestTests: XCTestCase {
    func test_propertiesEncoding_case01() throws {
        let uuid = UUID(uuidString: "d2e05b4b-6d2f-4ef6-b1e6-2e2cf5a8e7c3")!
        let parentId = Page.Identifier(uuid)
        let given = PageCreateRequest(
            parent: .page(parentId),
            properties: ["title": .init(type: .title([.init(string: "Lorem ipsum")]))],
            children: []
        )

        let result = try encodeToJson(given)

        XCTAssertEqual(result, #"{"children":[],"parent":{"page_id":"D2E05B4B-6D2F-4EF6-B1E6-2E2CF5A8E7C3"},"properties":{"title":{"title":[{"text":{"content":"Lorem ipsum"}}]}}}"#)
    }

    func test_propertiesAndChildrenEncoding_case01() throws {
        let uuid = UUID(uuidString: "d2e05b4b-6d2f-4ef6-b1e6-2e2cf5a8e7c3")!
        let parentId = Page.Identifier(uuid)
        let children: [WriteBlock] = [
            .paragraph(["Lorem ipsum dolor sit amet, "], color: .default)
        ]
        let given = PageCreateRequest(
            parent: .page(parentId),
            properties: ["title": .init(type: .title(["Lorem ipsum"]))],
            children: children
        )

        let result = try encodeToJson(given)

        XCTAssertEqual(result, #"{"children":[{"object":"block","paragraph":{"color":"default","rich_text":[{"text":{"content":"Lorem ipsum dolor sit amet, "}}]},"type":"paragraph"}],"parent":{"page_id":"D2E05B4B-6D2F-4EF6-B1E6-2E2CF5A8E7C3"},"properties":{"title":{"title":[{"text":{"content":"Lorem ipsum"}}]}}}"#)
    }

    func test_childrenEncoding_case01() throws {
        let uuid = UUID(uuidString: "d2e05b4b-6d2f-4ef6-b1e6-2e2cf5a8e7c3")!
        let parentId = Page.Identifier(uuid)
        let children: [WriteBlock] = [
            .paragraph(["Lorem ipsum dolor sit amet, "])
        ]

        let given = PageCreateRequest(
            parent: .page(parentId),
            properties: [:],
            children: children
        )

        let result = try encodeToJson(given)

        XCTAssertEqual(result, #"{"children":[{"object":"block","paragraph":{"color":"default","rich_text":[{"text":{"content":"Lorem ipsum dolor sit amet, "}}]},"type":"paragraph"}],"parent":{"page_id":"D2E05B4B-6D2F-4EF6-B1E6-2E2CF5A8E7C3"},"properties":{}}"#)
    }
    
    func test_childrenEncoding_case02() throws {
        let uuid = UUID(uuidString: "d2e05b4b-6d2f-4ef6-b1e6-2e2cf5a8e7c3")!
        let parentId = Page.Identifier(uuid)
        let children: [WriteBlock] = [
            .columnList(columns: [
                .column([
                    .paragraph(["Column 1"], color: .yellow)
                ]),
                .column([
                    .paragraph(["Column 2"], color: .green)
                ])
            ])
        ]

        let given = PageCreateRequest(
            parent: .page(parentId),
            properties: [:],
            children: children
        )

        let result = try encodeToJson(given)

        XCTAssertEqual(result, #"{"children":[{"column_list":{"children":[{"column":{"children":[{"paragraph":{"color":"yellow","rich_text":[{"text":{"content":"Column 1"}}]},"type":"paragraph"}]},"type":"column"},{"column":{"children":[{"paragraph":{"color":"green","rich_text":[{"text":{"content":"Column 2"}}]},"type":"paragraph"}]},"type":"column"}]},"object":"block","type":"column_list"}],"parent":{"page_id":"D2E05B4B-6D2F-4EF6-B1E6-2E2CF5A8E7C3"},"properties":{}}"#)
    }
}
