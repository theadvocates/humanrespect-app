export const categories = [
  {
    id: 'money',
    label: 'Your money',
    items: [
      { id: 'income-tax', label: 'Income tax', mechanism: 'Pay, or face penalties and eventually prison' },
      { id: 'property-tax', label: 'Property tax', mechanism: 'Pay, or your home is seized, even one you own outright' },
      { id: 'sales-tax', label: 'Sales tax', mechanism: 'Added to every purchase; a business that does not collect it is fined and can be shut down' },
      { id: 'social-security', label: 'Social Security / Medicare', mechanism: 'Taken from every paycheck; no way to opt out' },
    ]
  },
  {
    id: 'services',
    label: 'Services',
    items: [
      { id: 'public-schools', label: 'Public schools', mechanism: 'Funded by your taxes whether or not you use them' },
      { id: 'roads', label: 'Roads and infrastructure', mechanism: 'Gas taxes and general revenue; you cannot fund only the roads you use' },
      { id: 'police', label: 'Police and courts', mechanism: 'Funded by your taxes; no option to pay for a different provider' },
      { id: 'military', label: 'Military and defense', mechanism: 'You fund every operation, including the ones you oppose' },
    ]
  },
  {
    id: 'rules',
    label: 'Rules and regulations',
    items: [
      { id: 'min-wage', label: 'Minimum wage laws', mechanism: 'Makes it illegal to hire someone who agrees to work for less' },
      { id: 'drug-laws', label: 'Drug prohibition', mechanism: 'Arrest and possible jail for what you choose to consume' },
      { id: 'licensing', label: 'Occupational licensing', mechanism: 'Government permission required to work in many trades' },
      { id: 'zoning', label: 'Zoning and building codes', mechanism: 'Limits on how you use property you own' },
      { id: 'regulations', label: 'Business regulations', mechanism: 'Comply, or face fines, closure, or prison' },
      { id: 'env-regs', label: 'Environmental regulations', mechanism: 'Required compliance, backed by fines and penalties' },
    ]
  }
]

export const allItemIds = categories.flatMap(cat => cat.items.map(i => i.id))
export const totalItems = allItemIds.length
