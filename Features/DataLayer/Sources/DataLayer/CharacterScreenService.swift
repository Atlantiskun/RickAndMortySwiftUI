import RickNMortyAPI

public class CharacterScreenService {
    public init() {}

    public func getEpisodeInfo(by url: String) async throws -> Episode {
        do {
            let episode = try await EpisodeApi.methods.getEpisode(by: url)
            return episode
        } catch {
            print("error: \(error)")
            throw(error)
        }
    }
}
