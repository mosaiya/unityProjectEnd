using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Item : MonoBehaviour
{

    public int id;
    public string type;
    public string description;
    public Sprite icon;
    public bool pickedUp;

    [HideInInspector]
    public bool equipped;
    [HideInInspector]
    public GameObject weapon;
    [HideInInspector]
    public GameObject weaponManager;
    public bool playerWeapon;

    public void Start()
    {
        weaponManager = GameObject.FindWithTag("WeaponManager");
        if (!playerWeapon)
        {
            int allWeapons = weaponManager.transform.childCount;
            for(int i = 0; i < allWeapons; i++)
            {
                if(weaponManager.transform.GetChild(i).gameObject.GetComponent<Item>().id == id)
                {
                    weapon = weaponManager.transform.GetChild(i).gameObject;
                }
            }
        }
    }
    public void Update()
    {
        if (equipped)
        {
            if (Input.GetKeyDown(KeyCode.G))
            {
                equipped = false;
            }
            if(equipped == false)
            {
                this.gameObject.SetActive(false);
            }
        }
    }
    public void ItemUsage()
    {
        //weapon

        if(type == "Weapon")
        {
            Debug.Log("picked");
            weapon.SetActive(true);
            weapon.GetComponent<Item>().equipped = true;
        }
    }

}
