# frozen_string_literal: true

module ContractsHelper
  def contract_markup_pct_color(pct)
    return 'text-green-500' if pct.negative?

    return 'text-red-500' if pct >= 50 && pct < 100

    'text-gray-500 dark:text-zinc-500 dark:text-zinc-200'
  end
end
