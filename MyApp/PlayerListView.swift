import SwiftUI

// MARK: - 球員名冊列表頁面 (PlayerListView)
struct PlayerListView: View {
    @State private var selectedSchool: School? = nil
    @State private var searchText: String = ""

    private var filteredPlayers: [Player] {
        MockData.players.filter { player in
            let matchesSchool = (selectedSchool == nil || player.school == selectedSchool)
            let matchesSearch = searchText.isEmpty ||
                player.name.localizedCaseInsensitiveContains(searchText) ||
                player.signatureMove.localizedCaseInsensitiveContains(searchText) ||
                player.school.rawValue.localizedCaseInsensitiveContains(searchText)
            return matchesSchool && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 頂部學校切換列
                schoolFilterBar

                // 球員清單
                List {
                    Section {
                        ForEach(filteredPlayers) { player in
                            NavigationLink {
                                PlayerDetailView(player: player)
                            } label: {
                                PlayerRowView(player: player)
                            }
                        }
                    } header: {
                        HStack {
                            Text("全部球員 (\(filteredPlayers.count))")
                            Spacer()
                            if selectedSchool != nil {
                                Button("重設") {
                                    withAnimation {
                                        selectedSchool = nil
                                    }
                                }
                                .font(.caption)
                                .textCase(nil)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("球員名冊")
            .searchable(text: $searchText, prompt: "搜尋球員、學校或絕技")
        }
    }

    // MARK: - 學校快速篩選列
    private var schoolFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedSchool = nil
                    }
                } label: {
                    Text("全部學校")
                        .font(.caption.bold())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(selectedSchool == nil ? Color.orange : Color(UIColor.secondarySystemFill))
                        .foregroundColor(selectedSchool == nil ? .white : .primary)
                        .clipShape(Capsule())
                }

                ForEach(School.allCases) { school in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedSchool = (selectedSchool == school ? nil : school)
                        }
                    } label: {
                        Text(school.rawValue)
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(selectedSchool == school ? school.themeColor : Color(UIColor.secondarySystemFill))
                            .foregroundColor(selectedSchool == school ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(UIColor.systemBackground))
    }
}
