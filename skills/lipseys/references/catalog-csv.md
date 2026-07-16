# Lipsey's Catalog CSV

Use this reference when inspecting or importing a Lipsey's catalog CSV. It describes a small
user-supplied example observed on 2026-07-16; it is evidence, not a promise that every account,
export, or future version has the same schema.

## Observed Shape

- The example contained 19 data rows and 85 consistently parsed columns.
- The first 78 columns, from `ITEMNO` through `ITEMGROUP`, appeared distributor-oriented.
- Seven trailing columns used retailer-specific price, profit, and label names. They are not
  confirmed Lipsey's fields and must be treated as project-owned enrichment unless authoritative
  evidence says otherwise.
- Headers were mostly uppercase without spaces. Do not normalize names before preserving the raw
  source contract.
- Empty fields were common, including fields that were empty for every row in this small sample.
  Do not remove a column or infer that it is unsupported from this sample alone.

The apparently project-owned trailing fields were:

```text
USPK DEFAULT PRICE
DEFAULT PROFIT $
USPK STEP2 PRICE
USPK FINAL PRICE
FINAL PROFIT $
FINAL PROFIT %
Label
```

Keep source fields and enrichment fields in separate schemas or pipeline stages. Never send
retailer-derived profit or merchandising fields back to Lipsey's unless a current write contract
explicitly requires them.

## Observed Source-Oriented Columns

### Identity and merchandising

```text
ITEMNO, DESCRIPTION1, DESCRIPTION2, UPC, MANUFACTURERMODELNO, MSRP, MODEL,
MANUFACTURER, TYPE, ITEMTYPE, FAMILY, ITEMGROUP, IMAGENAME
```

- Treat `ITEMNO`, `UPC`, and `MANUFACTURERMODELNO` as text identifiers. In the example, every UPC
  was 12 digits and most manufacturer model numbers looked numeric; numeric appearance does not
  make either safe for arithmetic or numeric storage.
- The example had unique values for those three identifiers, but uniqueness is not established as
  a universal contract.
- `IMAGENAME` held filenames rather than confirmed absolute URLs, and one image name could be
  shared by multiple rows. Do not use it as a product key.
- Keep `TYPE`, `ITEMTYPE`, `FAMILY`, and `ITEMGROUP` distinct. They showed different classification
  granularity and should not be collapsed without a destination mapping policy.
- Treat `DESCRIPTION2` as an independent optional field, not automatically as a continuation of
  `DESCRIPTION1`.

### Availability, price, and flags

```text
QUANTITY, ALLOCATED, CANDROPSHIP, ONSALE, PRICE, CURRENTPRICE, RETAILMAP,
EXCLUSIVE, EXCLUSIVETYPE
```

- `QUANTITY` was an integer-like field and included zero. Preserve it separately from allocation,
  drop-ship, sale, and restriction flags.
- Boolean-like values were uppercase `TRUE` and `FALSE` strings in the CSV. Parse accepted literals
  explicitly; reject or quarantine unknown spellings instead of relying on language truthiness.
- All observed `ALLOCATED` values were `FALSE`, so the sample provides no evidence about how an
  allocated row combines with quantity or price.
- In this sample, `CURRENTPRICE` differed from `PRICE` on the two rows marked `ONSALE=TRUE` and
  matched it on the other rows. Treat that as an observed relationship to test, not a documented
  pricing rule.
- `RETAILMAP` included zero. Do not interpret zero as “no MAP restriction” without authoritative
  documentation and project policy.
- Parse money-like fields with decimal arithmetic. Determine currency from current documentation
  or account context rather than the column names alone.

### Compliance and regulated-product metadata

```text
FFLREQUIRED, SOTREQUIRED, BOUNDBOOKMANUFACTURER, BOUNDBOOKMODEL, BOUNDBOOKTYPE,
NFATHREADPATTERN, NFAATTACHMENTMETHOD, NFABAFFLETYPE,
SILENCERCANBEDISASSEMBLED, SILENCERCONSTRUCTIONMATERIAL, NFADBREDUCTION,
SILENCEROUTSIDEDIAMETER, NFAFORM3CALIBER, DBREDUCTION
```

- Preserve `FFLREQUIRED` and `SOTREQUIRED` as separate raw flags. Do not infer legal sellability or
  fulfillment eligibility from either field alone.
- Preserve bound-book values exactly in the raw layer. The example included case variations that
  would compare differently without normalization.
- Keep NFA and suppressor fields sparse and product-conditional. Missing does not mean false or not
  applicable unless the contract says so.

### Product attributes

```text
CALIBERGAUGE, ACTION, BARRELLENGTH, CAPACITY, FINISH, OVERALLLENGTH, RECEIVER,
SAFETY, SIGHTS, STOCKFRAMEGRIPS, MAGAZINE, WEIGHT, CHAMBER, DRILLEDANDTAPPED,
RATEOFTWIST, ADDITIONALFEATURE1, ADDITIONALFEATURE2, ADDITIONALFEATURE3, SPECIAL,
SIGHTSTYPE, CASE, CHOKE, FINISHTYPE, FRAME, GRIPTYPE, HANDGUNSLIDEMATERIAL,
COUNTRYOFORIGIN
```

- Many attribute fields were sparse and applicable only to some product types.
- Several measurements embedded units or punctuation in text, such as length and weight fields.
  Preserve the raw value; create normalized numeric/unit fields only through an explicit parser
  that retains the original.
- Do not turn blank boolean-adjacent fields into `FALSE`. Blank, false, unknown, and not applicable
  may be different states.

### Optic attributes

```text
OPTICMAGNIFICATION, MAINTUBESIZE, ADJUSTABLEOBJECTIVE, OBJECTIVESIZE,
OPTICADJUSTMENTS, ILLUMINATEDRETICLE, RETICLE, SCOPECOVERINCLUDED
```

Keep these fields product-conditional. In the example, several flag columns contained `FALSE`
even when related descriptive columns were blank; do not infer a general cross-field rule from
that pattern.

### Shipping and dimensions

```text
SHIPPINGWEIGHT, ITEMLENGTH, ITEMWIDTH, ITEMHEIGHT, PACKAGELENGTH, PACKAGEWIDTH,
PACKAGEHEIGHT
```

- `SHIPPINGWEIGHT` and populated package dimensions were numeric-like decimals.
- Units were not established by the CSV header. Do not assume pounds or inches without current
  documentation or account-specific export instructions.
- Item dimensions were entirely blank in the small sample while most package dimensions were
  populated. Preserve these as separate concepts.

## Import Contract

For every catalog snapshot:

1. Capture the source filename, retrieval time, file hash, encoding, delimiter, row count, and exact
   ordered headers outside the universal skill.
2. Fail or quarantine rows whose parsed width differs from the header width.
3. Compare headers with the last accepted schema and review additions, removals, and renames before
   publishing.
4. Store raw source values before normalization or destination mapping.
5. Parse identifiers as strings, prices with decimal arithmetic, quantities as validated integers,
   and booleans from an explicit allowlist.
6. Keep blanks distinct from zero and false.
7. Timestamp availability and price data; a catalog CSV is a snapshot, not live state.
8. Quarantine malformed regulated-product flags or identifiers instead of guessing.
9. Keep retailer calculations and destination fields out of the Lipsey's source model.
10. Test at least one sparse row, one zero-quantity row, one sale row, one restricted row, and one
    row containing delimiters or punctuation inside a field.

## Unverified Questions

Confirm these against current authenticated documentation before encoding business rules:

- Whether the 78-column source-oriented block is the complete current export contract
- Whether `ITEMNO` is guaranteed unique and stable across snapshots
- The formal difference among `PRICE`, `CURRENTPRICE`, `MSRP`, and `RETAILMAP`
- Currency, weight, and dimension units
- Whether image filenames require a documented base URL or another lookup
- Exact semantics for zero MAP, allocation, drop shipping, exclusivity, and missing values
- Whether column presence or ordering varies by account or export type
