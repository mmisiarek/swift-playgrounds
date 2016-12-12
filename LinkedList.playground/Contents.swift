enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}
