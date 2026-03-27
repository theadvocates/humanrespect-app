export const categories = [
  {
    id: 'money',
    label: 'Your money',
    items: [
      { id: 'income-tax', label: 'Income tax', mechanism: 'Compulsory payment; non-compliance leads to penalties and imprisonment' },
      { id: 'property-tax', label: 'Property tax', mechanism: 'Pay or your home is seized, even if fully paid for' },
      { id: 'sales-tax', label: 'Sales tax', mechanism: 'Added to every purchase; businesses face closure for non-collection' },
      { id: 'social-security', label: 'Social Security / Medicare', mechanism: 'Mandatory payroll deduction; no individual opt-out' },
    ]
  },
  {
    id: 'services',
    label: 'Services',
    items: [
      { id: 'public-schools', label: 'Public schools', mechanism: 'Tax-funded regardless of whether you use them or have children' },
      { id: 'roads', label: 'Roads and infrastructure', mechanism: 'Gas taxes and general revenue; no option to fund only roads you use' },
      { id: 'police', label: 'Police and courts', mechanism: 'Tax-funded; no option to choose alternative dispute resolution' },
      { id: 'military', label: 'Military and defense', mechanism: 'Compulsory funding of all operations including those you oppose' },
    ]
  },
  {
    id: 'rules',
    label: 'Rules and regulations',
    items: [
      { id: 'min-wage', label: 'Minimum wage laws', mechanism: 'Criminalizes voluntary employment agreements below a threshold' },
      { id: 'drug-laws', label: 'Drug prohibition', mechanism: 'Imprisonment for personal consumption choices' },
      { id: 'licensing', label: 'Occupational licensing', mechanism: 'Government permission required to practice many professions' },
      { id: 'zoning', label: 'Zoning and building codes', mechanism: 'Restrictions on how you use property you own' },
      { id: 'regulations', label: 'Business regulations', mechanism: 'Comply or face fines, forced closure, or imprisonment' },
      { id: 'env-regs', label: 'Environmental regulations', mechanism: 'Mandated compliance backed by fines and penalties' },
    ]
  }
]

export const allItemIds = categories.flatMap(cat => cat.items.map(i => i.id))
export const totalItems = allItemIds.length
