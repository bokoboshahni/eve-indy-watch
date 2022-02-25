import React, { Fragment } from 'react'
import { Menu, Transition } from '@headlessui/react'

import '../../../../../../app/javascript/stylesheets/application.css'
import classNames from '../../../../utils/class-names'
import { ChevronDownIcon } from '@heroicons/react/solid'

const items = [
  { name: 'Settings', href: '/settings' },
  { name: 'Log out', href: '/auth/logout' }
]

export const UserMenu = (props) => {
  const user = props.user

  return (
    <Menu as="div" className="ml-4 relative">
      <div>
        <Menu.Button className="max-w-xs bg-surface rounded-full flex items-center typescale-label-large focus:outline-none hover:bg-primary hover:bg-opacity-8 dark:hover:bg-opacity-8 lg:p-2 lg:rounded-md">
          <img className="h-6 w-6 rounded-full" src={user.avatar_url} alt="" />
          <span className="hidden ml-3 text-on-surface typescale-label-large lg:block">
            <span className="sr-only">Open user menu for </span>
            {user.name}
          </span>
          <ChevronDownIcon
            className="hidden flex-shrink-0 ml-1 h-6 w-6 text-on-surface lg:block"
            aria-hidden="true"
          />
        </Menu.Button>
      </div>
      <Transition
        as={Fragment}
        enter="transition ease-out duration-100"
        enterFrom="transform opacity-0 scale-95"
        enterTo="transform opacity-100 scale-100"
        leave="transition ease-in duration-75"
        leaveFrom="transform opacity-100 scale-100"
        leaveTo="transform opacity-0 scale-95"
      >
        <Menu.Items className="origin-top-right absolute right-0 mt-2 w-48 rounded-md py-1 bg-surface-2 focus:outline-none">
          {items.map((item) => (
            <Menu.Item key={item.name}>
              {({ active }) => (
                <a
                  href={item.href}
                  className={classNames(
                    active ? 'bg-primary bg-opacity-12 dark:bg-opacity-12' : '',
                    'block px-4 py-2 typescale-label-large text-on-surface hover:bg-on-surface hover:bg-opacity-8'
                  )}
                >
                  {item.name}
                </a>
              )}
            </Menu.Item>
          ))}
        </Menu.Items>
      </Transition>
    </Menu>
  )
}

export default UserMenu
