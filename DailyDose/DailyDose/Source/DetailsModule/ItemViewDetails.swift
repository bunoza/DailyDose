import SwiftUI

struct ItemViewDetails: View {
    private var item: ItemRowModel

    init(item: ItemRowModel) {
        self.item = item
    }

    var body: some View {
        List {
            Section {} header: {
                VStack(alignment: .leading, spacing: 15) {
                    AsyncImage(url: URL(string: item.imageSource ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadius: 4))
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }

                    if let normalizedTitle = item.normalizedTitle {
                        Text(normalizedTitle)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                    }

                    if let text = item.text {
                        Text(text)
                            .foregroundStyle(Color.primary)
                    }
                }
            }
            .textCase(nil)
            .navigationTitle("in \(item.year)")
        }
    }
}
