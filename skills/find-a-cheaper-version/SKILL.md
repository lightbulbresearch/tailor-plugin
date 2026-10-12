---
name: find-a-cheaper-version
description: Find a cheaper or alternative version of a piece of clothing with Tailor, such as a look-alike of something the user saw elsewhere, the same look at another store, or something similar on sale. Use when someone asks for a dupe, a cheaper option, alternatives, or "something like this but less".
---

# Find a cheaper version with Tailor

The goal is a piece that looks like the one the user wants, for less. Be honest that
these are look-alikes, not the same product.

## 1. Pin down the original

- **A product Tailor already showed**: use its `product_id`, `price` and
  `product_type`.
- **Something from elsewhere** (described, linked or in a photo): describe it the way
  a product page would, with colour, cut, fabric, pattern, length and details, and
  note its price if the user knows it. Tailor only searches its own index, so don't
  try to open or buy from other sites.

Also confirm the user's **country** (`za`, `us` or `gb`) and **department**. Ask what
"cheaper" means if it's unclear; by default, aim for well under the original price.

## 2. Search

- **For a Tailor product**: call `find_similar_products` with its `product_id`,
  `price_max` below its price, and the same `product_type`. Without `product_type`,
  look-alikes can include other kinds of item. To look at one other retailer, add
  `store_code`. To see only discounted items, add `on_sale: true`.
- **For something from elsewhere**: call `search_products` with the description,
  `country`, `department` and `price_max`. If one result is close, run
  `find_similar_products` on it, with the same `product_type`, to find more like it.
- **For the same item in another colour**: use `tailor_product` with the change as the
  desired result and `colour_family` set.

Pass `exclude_ids` for products already shown, to get fresh results.

## 3. Present

Call `show_products` with the best 3 to 6 options, closest look first, and a `title`
such as "Cheaper takes on the camel coat". Don't re-list them in text. Add:

- for each option worth mentioning, how close it is and what's different (fabric,
  length, details)
- how much it saves against the original, in the same currency

Prices are in each shop's own currency and aren't converted, so only compare prices
within one country.
