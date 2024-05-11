import SwiftUI

struct ItemRowView: View {
    @StateObject private var viewModel: ItemRowViewModel

    init(viewModel: @autoclosure @escaping () -> ItemRowViewModel) {
        _viewModel = .init(wrappedValue: viewModel())
    }

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: viewModel.imageSource ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 4))
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75, alignment: .center)

            VStack(alignment: .leading) {
                if let categoryText = viewModel.categoryText {
                    Text(categoryText)
                        .font(.caption)
                        .lineLimit(1)
                } else {
                    Text("categoryText")
                }

                if let normalizedTitle = viewModel.normalizedTitle {
                    Text(normalizedTitle)
                        .font(.callout)
                        .lineLimit(2)
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
        }
    }
}
