import PostgreSQLProvider

extension Config {
    public func setup() throws {
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }

    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(PostgreSQLProvider.Provider.self)
    }

    private func setupPreparations() throws {
        preparations.append(User.self)
        preparations.append(Experience.self)
        preparations.append(Skill.self)
    }
}
