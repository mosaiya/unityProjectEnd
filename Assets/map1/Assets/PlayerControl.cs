using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerControl : MonoBehaviour
{
    static Animator anim;
    public float speed = 1.0F;
    public float rotationSpeed = 100.0F;
    public Inventory Inventory;
    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent <Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        //movement
        if (anim.GetBool("isDead") == false)
        {

            float translation = Input.GetAxis("Vertical") * speed;
            float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
            translation *= Time.deltaTime;
            rotation *= Time.deltaTime;
            transform.Translate(0, 0, translation);
            transform.Rotate(0, rotation, 0);
            if (Input.GetButtonDown("Jump"))
            {
                anim.SetTrigger("isJumping");
            }
            if (Input.GetMouseButtonDown(0))
            {
                anim.SetTrigger("isThrowing");

            }
            if (translation != 0)
            {
                anim.SetBool("isIdle", false);
                if (translation < 0)
                {
                    anim.SetBool("isWalkingB", true);
                }
                else
                {
                    anim.SetBool("isWalking", true);
                }
                if (Input.GetKeyDown(KeyCode.LeftShift))
                {
                    anim.SetBool("isRunning", true);
                    speed += 1f;
                }
                if (Input.GetKeyUp(KeyCode.LeftShift))
                {
                    anim.SetBool("isRunning", false);
                    speed -= 1f;
                }
            }
            else
            {
                anim.SetBool("isWalkingB", false);
                anim.SetBool("isWalking", false);
                anim.SetBool("isIdle", true);
            }
        }
        ///life
        if(HealthBarScript.health <= 0)
        {
            anim.SetBool("isDead", true);
            Debug.Log("dead");
            anim.SetBool("isWalkingB", false);
            anim.SetBool("isWalking", false);
            anim.SetBool("isIdle", false);
        }
    }
}
