// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module aptos_blog_example::resource_account {
    use aptos_framework::account;
    use std::bcs;
    use std::signer;
    use std::vector;

    friend aptos_blog_example::genesis_account;

    struct ResourceAccount has key {
        cap: account::SignerCapability,
    }

    public(friend) fun initialize(genisis_account: &signer) {
        let seed = bcs::to_bytes(&signer::address_of(genisis_account));
        vector::append(&mut seed, b"AptosBlogExample");
        let (_resource_account_signer, resouce_account_signer_cap) = account::create_resource_account(
            genisis_account, seed);
        move_to(genisis_account, ResourceAccount {
            cap: resouce_account_signer_cap,
        });
    }

    public(friend) fun resource_account_signer(addr: address): signer acquires ResourceAccount {
        let res_account = borrow_global<ResourceAccount>(addr);
        account::create_signer_with_capability(&res_account.cap)
    }
}

