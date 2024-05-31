import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var appState = AppState()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Source language:")
                        Spacer()
                        Picker("", selection: $appState.language) {
                            ForEach(SupportedLanguage.allCases, id: \.rawValue) { language in
                                Text(language.description)
                                    .tag(language)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
