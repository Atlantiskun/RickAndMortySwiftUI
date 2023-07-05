import RickNMortyAPI

public class MainScreenService {
    public var currentPage: Int = 1
    public var isNextPageExist: Bool = false
    public var characters: [Character] = []

    public init() {}

    public func getAllCharacters(from page: Int) async throws {
        do {
            let characters = try await CharactersApi.methods.getAllCharacters(page: page)
            isNextPageExist = characters.info.next != nil
            self.characters.append(contentsOf: characters.results)
        } catch {
            print("error: \(error)")
        }
    }

    public func nextPage() async throws {
        guard isNextPageExist else { return }
        do {
            currentPage += 1
            try await getAllCharacters(from: currentPage)
        } catch {
            print("error: \(error)")
        }
    }
}
