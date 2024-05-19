import SwiftUI

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SectionIndexTitles: View {
    class IndexTitleState: ObservableObject {
        var currentTitleIndex = 0
        var titleSize: CGSize = .zero
    }

    let proxy: ScrollViewProxy
    let titles: [String]
    let impactMed = UIImpactFeedbackGenerator(style: .medium)

    @GestureState private var dragLocation: CGPoint = .zero
    @StateObject var indexState = IndexTitleState()

    var body: some View {
        VStack {
            ForEach(titles, id: \.self) { title in
                Text(title)
                    .foregroundColor(.blue)
                    .modifier(SizeModifier())
                    .onPreferenceChange(SizePreferenceKey.self) {
                        self.indexState.titleSize = $0
                    }
                    .onTapGesture {
                        proxy.scrollTo(title, anchor: .center)
                    }
            }
        }
        .gesture(
            DragGesture(minimumDistance: indexState.titleSize.height, coordinateSpace: .named(titles.first))
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                    scrollTo(location: state)
                }
        )
    }

    private func scrollTo(location: CGPoint) {
        if indexState.titleSize.height > 0 {
            let index = Int(location.y / indexState.titleSize.height)
            if index >= 0 && index < titles.count {
                if indexState.currentTitleIndex != index {
                    indexState.currentTitleIndex = index
                    print(titles[index])
                    DispatchQueue.main.async {
                        impactMed.impactOccurred()
                        withAnimation {
                            proxy.scrollTo(titles[indexState.currentTitleIndex], anchor: .top)
                        }
                    }
                }
            }
        }
    }
}

struct ScrollableVerticalList: View {
    @Environment(\.colorScheme) var colorScheme

    @State var items: [ItemRowModel]
    private var years: [Int]

    var fontColor: Color {
        colorScheme == .light ? .white : .black
    }

    init(items: [ItemRowModel], years: [Int]) {
        self.items = items
        self.years = years
    }

    func getItems(with year: Int) -> [ItemRowModel] {
        items.filter { $0.year == String(year) }
    }

    var body: some View {
        ScrollViewReader { scrollView in
            ZStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(items) { item in
                            NavigationLink {
                                ItemViewDetails(item: item)
                            } label: {
                                ItemRowView(viewModel: ItemRowViewModel(item: item))
                                    .containerRelativeFrame(.vertical, alignment: .center)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .id(item.year)
                        }
                    }
                }
                .scrollIndicators(.never)
                .ignoresSafeArea(edges: .all)
                .scrollTargetLayout()
                .scrollTargetBehavior(.paging)

                HStack {
                    Spacer()
                    VStack {
                        VStack {
                            SectionIndexTitles(proxy: scrollView, titles: retrieveSectionTitles())
                                .font(.footnote)
                        }
                        .padding(5)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [fontColor.opacity(0.7), fontColor, fontColor.opacity(0.7)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                    }
                }
            }
        }
    }

    func retrieveSectionTitles() -> [String] {
        years.map { String($0) }
    }
}
