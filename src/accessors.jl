"""
Basically every API function returns some struct, and finding out what field you need to access can be hard, especially when you're working with multiple `Forge`s.
To help with that, this module contains accessor functions that abstract the field names away.

Because the fields of forge types are all nullable, you should be prepared for all of these functions to return `nothing`.
But don't worry about handling the `nothing` case when you chain them, because each accessor implements `f(::Nothing) = nothing`.
"""
module Accessors

export
    clone_url,
    created_at,
    description_of,
    id_of,
    is_owned_by_organization,
    is_private,
    name_of,
    owner_of,
    sha_of,
    title_of,
    updated_at,
    web_url

"""
    clone_url(repo)

Return the URL at which a repository can be cloned.
"""
clone_url(::Nothing) = nothing

"""
    created_at(x::T)

Return some resource's time of creation.
"""
created_at(::Nothing) = nothing

"""
    description_of(x::T)

Return some resource's description, body text, etc.
"""
description_of(::Nothing) = nothing

"""
    id_of(x::T)

Return a (usually) unique identifier for `x`.
For example, some `User` type might implement this function to return the user ID.
"""
id_of(::Nothing) = nothing

"""
    is_owned_by_organization(repo)

Return whether or not a repository is owned by a group or organization (as opposed to a user).
"""
is_owned_by_organization(::Nothing) = nothing

"""
    is_private(repo)

Return whether or not a repository is private.
"""
is_private(Nothing) = nothing

"""
    name_of(x::T)

Return a (usually string) short representation of `x`.
For example, some `User` type might implement this function to return the username.
"""
name_of(::Nothing) = nothing

"""
    owner_of(x::T)

Return the owner of some resource (usually a `User` type).
"""
owner_of(::Nothing) = nothing

"""
    sha_of(x::T)

Return the SHA hash of some Git-related thing.
"""
sha_of(::Nothing) = nothing

"""
    title_of(x::T)

Return some resource's title.
"""
title_of(::Nothing) = nothing

"""
    updated_at(x::T)

Return some resource's time of last update.
"""
updated_at(::Nothing) = nothing

"""
    web_url(x::T)

Return the URL at which something can be accessed from a browser.
"""
web_url(::Nothing) = nothing

end
