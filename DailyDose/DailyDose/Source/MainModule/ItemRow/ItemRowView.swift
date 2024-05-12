import SwiftUI

struct ItemRowView: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject private var viewModel: ItemRowViewModel

    init(viewModel: @autoclosure @escaping () -> ItemRowViewModel) {
        _viewModel = .init(wrappedValue: viewModel())
    }

    var gradientColor: Color {
        colorScheme == .light ? .black : .white
    }

    var fontColor: Color {
        colorScheme == .light ? .white : .black
    }

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: viewModel.imageSource ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: UIScreen().bounds.width, height: 200)

            LinearGradient(colors: [gradientColor.opacity(0.5), .black.opacity(0), .black.opacity(0)], startPoint: .leading, endPoint: .trailing)
            LinearGradient(colors: [gradientColor, .black.opacity(0)], startPoint: .bottom, endPoint: .top)

            showOverlayText()
                .padding()
        }
    }

    private func showOverlayText() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Spacer()

                if let categoryText = viewModel.categoryText {
                    Text(categoryText)
                        .font(.caption)
                        .lineLimit(1)
                        .bold()
                } else {
                    Text("categoryText")
                }

                if let normalizedTitle = viewModel.normalizedTitle {
                    Text(normalizedTitle)
                        .font(.title3)
                        .lineLimit(2)
                        .bold()
                } else {
                    Text("normalizedTitle")
                }

                if let text = viewModel.text {
                    Text(text)
                        .font(.caption)
                        .lineLimit(2)
                } else {
                    Text("text")
                }
            }
            .foregroundStyle(fontColor)
            Spacer()
        }
    }
}

#Preview {
    List {
        ItemRowView(
            viewModel: ItemRowViewModel(
                item: ItemRowModel(
                    date: Date(),
                    year: "2025",
                    normalizedTitle: "normalized title normalized title",
                    imageSource: "https://upload.wikimedia.org/wikipedia/en/thumb/b/b4/JewishMarketPostvilleIowa.jpg/320px-JewishMarketPostvilleIowa.jpg",
                    text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                    category: "events"
                )
            )
        )
        .listRowInsets(EdgeInsets())

        ItemRowView(
            viewModel: ItemRowViewModel(
                item: ItemRowModel(
                    date: Date(),
                    year: "2025",
                    normalizedTitle: "normalized title normalized title",
                    imageSource: "https://upload.wikimedia.org/wikipedia/en/thumb/b/b4/JewishMarketPostvilleIowa.jpg/320px-JewishMarketPostvilleIowa.jpg",
                    text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                    category: "events"
                )
            )
        )
        .listRowInsets(EdgeInsets())
    }
}
