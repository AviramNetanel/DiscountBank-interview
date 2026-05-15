import json
import sys

def extract(node, colors, typography):

    # COLORS
    fills = node.get("fills", [])
    if isinstance(fills, list):
        for f in fills:
            if f.get("type") == "SOLID":
                c = f.get("color", {})
                r = round(c.get("r", 0) * 255)
                g = round(c.get("g", 0) * 255)
                b = round(c.get("b", 0) * 255)

                hex_color = f"#{r:02X}{g:02X}{b:02X}"
                colors.add(hex_color)

    # TYPOGRAPHY
    if node.get("type") == "TEXT":
        style = node.get("style", {})

        typography.add((
            style.get("fontFamily"),
            style.get("fontSize"),
            style.get("fontWeight")
        ))

    # RECURSION
    for child in node.get("children", []):
        extract(child, colors, typography)


def main():
    file_path = sys.argv[1]

    with open(file_path) as f:
        data = json.load(f)

    nodes = data.get("nodes", {})
    first_key = list(nodes.keys())[0]
    node = nodes[first_key]["document"]

    colors = set()
    typography = set()

    extract(node, colors, typography)

    output = {
        "colors": sorted(list(colors)),
        "typography": [
            {
                "fontFamily": t[0],
                "fontSize": t[1],
                "fontWeight": t[2]
            }
            for t in typography
        ]
    }

    with open("design_tokens.json", "w") as f:
        json.dump(output, f, indent=2)

    print("Saved → design_tokens.json")


if __name__ == "__main__":
    main()