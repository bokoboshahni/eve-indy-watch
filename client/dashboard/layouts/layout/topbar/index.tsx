import React from 'react'

import '../../../../../app/javascript/stylesheets/application.css'
import { BellIcon, MenuAlt1Icon } from '@heroicons/react/outline'
import UserMenu from './user-menu'
import GlobalSearch from './global-search'

export const Topbar = (props) => {
  const setSidebarOpen = props.setSidebarOpen
  const user = props.user

  return (
    <div className="relative z-10 flex-shrink-0 flex h-16 bg-surface">
      <button
        type="button"
        className="px-4 text-on-surface hover:bg-primary hover:bg-opacity-8 dark:hover:bg-opacity-8 lg:hidden"
        onClick={() => setSidebarOpen(true)}
      >
        <span className="sr-only">Open sidebar</span>
        <MenuAlt1Icon className="h-6 w-6" aria-hidden="true" />
      </button>

      {/* Search bar */}
      <div className="flex-1 px-4 flex justify-between sm:px-6 lg:max-w-full lg:mx-auto lg:px-8">
        <div className="flex-1 flex">
          <GlobalSearch />
        </div>
        <div className="ml-4 flex items-center">
          <button
            type="button"
            className="bg-surface p-1 rounded-full text-on-surface hover:bg-primary hover:bg-opacity-8 dark:hover:bg-opacity-8"
          >
            <span className="sr-only">View notifications</span>
            <BellIcon className="h-6 w-6" aria-hidden="true" />
          </button>

          {/* Profile dropdown */}
          <UserMenu user={user} />
        </div>
      </div>
    </div>
  )
}

export default Topbar
