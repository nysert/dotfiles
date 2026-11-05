# HTML & Template Markup Conventions

Read when creating, modifying, or reviewing HTML or server-rendered markup templates (including ERB, Tera, Jinja, Nunjucks, and EJS). This is a **source-readability convention** that applies across Ruby, Rust, and Node projects. Use the project's frontend guidance for browser behavior, its UI/Tailwind guidance for styling, and its own template engine and formatter configuration as the sources of truth for syntax and mechanics.

## Priorities

1. Preserve rendered behavior and template semantics.
2. Make the HTML nesting and template branches obvious at a glance.
3. Keep simple markup compact; expand structural markup consistently.
4. Avoid formatting-only changes outside the touched area.

## Whitespace and nesting

- Use **spaces**, not literal tab characters.
- Indent HTML descendants by **2 spaces per element level**.
- Put structural opening/closing tags on separate lines: `div`, `section`, `form`, `table`, `thead`, `tbody`, `tr`, `nav`, `ul`, `li`, etc. Put structural sibling elements on separate lines too.
- Do **not** concatenate entire nested structures: `<div><table><tr>...</tr></table></div>` is not acceptable source layout.
- Keep template control-flow statements on their own lines when they govern HTML structure. Align `else`, `elsif`/`elif`, and closing directives with the corresponding opener.
- Indent each template branch body by **4 additional spaces** relative to its control-flow directive; continue normal 2-space nesting for descendant HTML inside that body.
- Put top-level template directives such as `extends`, `include`, and layout/section definitions on separate lines when safe.
- Use a **100-character soft width target**, not a mandate to break text, expressions, URLs, or attribute values in unsafe ways.
- Use blank lines between substantial sections when helpful, not between every tag or inside whitespace-sensitive elements.

## Compact elements and wrapping attributes

- Keep a short element and simple text inline: `<h1>Companies</h1>`, `<p a="a">abc</p>`, `<button type="submit">Save</button>`.
- Keep a single short attribute inline. Also keep multiple attributes on the same opening line if the whole opening tag fits within the width target.
- If the **opening tag** exceeds the width target, break its attributes onto separate lines, indent attributes 2 spaces beyond the opening `<`, and align the final `>` with the opening `<`.
- Do not split a short tag solely because it contains an attribute. In particular, **never** produce a dangling `>` line for an otherwise short tag such as `<h1>Companies</h1>`.
- Keep short inline descendants together when readable, e.g. `<td><a href="{{ row.url }}">{{ row.key }}</a></td>`. Split long or complex descendants when necessary.
- Do not reorder attributes, rewrite CSS classes, change quotes inside template expressions, or alter boolean/conditional attributes as formatting-only changes.
- Use ordinary HTML void elements correctly; do not add closing tags to `input`, `img`, `br`, etc.

**Preferred:**

```html
<h1>Companies</h1>
<p class="text-muted">Ready</p>
<button type="submit">Save</button>
<div class="scroll" tabindex="0" role="region" aria-label="Companies">
  <table>
    ...
  </table>
</div>

<input
  class="w-full rounded-md border border-border"
  name="source_revision_id"
  value="{{ page.source_revision_id }}"
  aria-describedby="source-revision-help"
>
```

**Avoid:**

```html
<h1
>
  Companies</h1>
<p
  a="a"
>
  abc
</p>
<div><table><thead><tr><th>Company</th></tr></thead></table></div>
```

## Template branch examples

The same indentation principle applies regardless of the delimiter syntax. Keep **template delimiters exactly as required by the engine**.

### Tera / Jinja-style example

```html
<tbody>
  {% for row in page.items %}
      <tr>
        <td><a href="{{ row.url }}">{{ row.key }}</a></td>
        <td>{{ row.jobs }}</td>
      </tr>
  {% else %}
      <tr>
        <td colspan="2">No company groups match.</td>
      </tr>
  {% endfor %}
</tbody>
```

### Ruby ERB example

```erb
<section>
  <% if @items.any? %>
      <ul>
        <% @items.each do |item| %>
            <li><%= item.name %></li>
        <% end %>
      </ul>
  <% else %>
      <p>No items</p>
  <% end %>
</section>
```

## Safety and engine-specific exceptions

- Preserve every template directive, expression, filter/helper, escaping rule, and whitespace-control marker (`{%- ... -%}`, ERB trim markers, etc.). Do not treat ERB, Tera, or Jinja as interchangeable syntaxes.
- Never insert newlines into a dynamic attribute value, a text node where whitespace matters, or an inline script/style expression just to meet line width.
- Take particular care with `pre`, `code`, `textarea`, `script`, `style`, inline links, mixed text nodes, and elements where CSS `white-space` affects the result.
- When a template conditionally opens an HTML element in one branch and closes it elsewhere, preserve its **rendered structure**. Do not force it through a generic HTML parser by moving tags across conditions.
- Do not parse JavaScript/CSS containing template directives as plain JavaScript/CSS. Preserve and review those sections independently.
- Preserve existing accessible names, ARIA relationships, form field names/values, hidden CSRF fields, route URLs, and escaping/security behavior.
- For JSX/TSX, Vue, Svelte, or other framework-specific components, follow the project's supported formatter and framework rules first; use these HTML conventions only where compatible.
- Existing project-specific formatting settings override these defaults when they have been explicitly chosen and are compatible with correct template rendering.

## Completion

- Check that structural HTML is visibly nested, simple tags remain compact, and template branch indentation is consistent.
- Review the diff for changed expressions, conditional attributes, whitespace-sensitive text, or script/style content.
- Render or test representative branches (nonempty/empty loops, error/success states, conditional attributes) after significant template restructuring.
- Run only the template-aware formatting/checking commands actually configured in the project. Do not claim a generic HTML formatter supports the active template engine without verification.
- Do not bulk-reformat unrelated templates just to enforce these conventions in a behavior-focused PR.
