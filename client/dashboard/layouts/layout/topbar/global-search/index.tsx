import React from 'react'

import '../../../../../../app/javascript/stylesheets/application.css'
import { SearchIcon } from '@heroicons/react/outline'

export const GlobalSearch = () => {
  return (
    <form className="w-full flex md:ml-0" action="#" method="GET">
      <label htmlFor="search-field" className="sr-only">
        Search
      </label>
      <div className="relative w-full text-neutral-400 dark:text-white dark:text-opacity-60 focus-within:text-neutral-600 dark:focus-within:text-opacity-90">
        <div
          className="absolute inset-y-0 left-0 flex items-center pointer-events-none"
          aria-hidden="true"
        >
          <SearchIcon className="h-6 w-6" aria-hidden="true" />
        </div>
        <input
          id="search-field"
          name="search-field"
          className="block w-full h-full pl-8 pr-3 py-2 bg-surface border-transparent typescale-label-medium text-on-surface placeholder-on-surface focus:outline-none focus:ring-0 focus:border-transparent"
          placeholder="Search"
          type="search"
        />
      </div>
    </form>
  )
}

export default GlobalSearch
