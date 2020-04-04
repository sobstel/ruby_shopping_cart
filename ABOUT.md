# ABOUT

Run `rake` to run tests.

## ASSUMPTIONS

- Item is a product in the basket (added for checkout), where price refers to
  the amount that customer needs to pay, and not actual product price.

- "Total price" rule is applied after "multiple item" rule, so reduced price
  for "Red Scarf" items is also reduced if checkout sum is over £60.

## DESIGN DECISIONS

- For design simplicity, a promotional rule class implements one `apply(items)`
  method, which is responsible for traversing items and reducing item's price if
  discount is applicable.

- Total price discount is applied as a 10% discount for each item separately.
  It should also allow to display new price for each item.
  However, this approach might have some limitation for possible future cases
  (eg. if we need to have a global rule like shipping rate discount or so).

- YAGNI approach has been used, so solution has been implemented for current
  requirements avoiding overengineering for future cases that might actually
  never happen.

- Item model (currently represented with struct) could also store orginal price,
  so - when displayed - it's easier to show full discount. It'll depend on business
  requirements though.

- It might be good to add unit tests for promotional rules, but for now they're
  covered by checkout test (which in fact plays a role of integration test for
  checkout process here).
