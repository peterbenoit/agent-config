# Lipsey's Status Semantics

Use this reference when translating Lipsey's availability into application behavior.

## Allocated

Lipsey's public FAQ describes an allocated item as high-demand, short-supply inventory divided
among sales executives, who determine distribution to dealers. Adding such an item to a wish list
communicates interest but does not guarantee that the dealer will receive it.

Therefore:

- Do not treat `allocated` as ordinary available inventory.
- Do not promise purchase or fulfillment based only on catalog presence or wish-list state.
- Preserve the allocated status for downstream policy decisions.
- Obtain project-specific guidance before exposing an allocated item as purchasable.

## Unknown and Undocumented States

Do not extrapolate from the word used by another distributor. For every newly observed status:

1. Preserve the raw value.
2. Record the source, date, and response context.
3. Confirm its meaning in official or authenticated documentation.
4. Define project behavior separately from vendor meaning.
5. Default to non-sellable when the consequence of a wrong interpretation is overselling or an
   unfulfillable order.

Keep these concepts separate:

- **Vendor meaning:** what Lipsey's says the state represents
- **Account entitlement:** whether this dealer can act on the state
- **Project policy:** whether and how the destination storefront exposes it
- **Observed quantity:** a timestamped numeric value, if provided

Never collapse these concepts into a single `inStock` boolean without an explicit, tested mapping.
